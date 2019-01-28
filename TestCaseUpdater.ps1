$folderPath = $env:TestAssemblyPath;
$testAssemblyFilter = $env:TestAssemblyFilePattern;
$testCategoryTagPrefix = $env:TestCategoryTagPrefix;
$apiVersion = $env:RestApiVersion

$pat = $env:SYSTEM_ACCESSTOKEN
$baseDevOpsUrl = $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI
$teamProject = $env:SYSTEM_TEAMPROJECT

$User=""

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User,$pat)));
$header = @{Authorization=("Basic {0}" -f $base64AuthInfo)};

Write-Host ("Test assembly path: " + $folderPath)
$testAssemblies = (Get-ChildItem -Path $folderPath -Recurse -Filter $testAssemblyFilter).FullName

function FormatSummary([string] $summaryText)
{
    $summaryText = ($summaryText.Trim() -replace '<para.',"<p>" -replace '</para>","</p>' `
                                        -replace '<list type="bullet">','<ul>' -replace '</list>','</ul>' `
                                        -replace '<item>','<li>' -replace '</item>','</li>' `
                                        -replace '<description>','' -replace '</description>','' `
                                        -replace '`r','</br>' -replace '`n','</br>').Trim()
    $summaryText
}

foreach($testAssembly in $testAssemblies)
{
    Write-Host ("******************************************************************")
    Write-Host ("Test assembly found: " + $testAssembly)
    Write-Host ("******************************************************************")

    $asm = [System.Reflection.Assembly]::LoadFrom($testAssembly)

    $testDocumentationFilePath = $testAssembly -replace ".dll",".xml"
    [xml]$assemblyDocument = Get-Content -Path $testDocumentationFilePath
    
    $classes =  $asm.GetTypes()
    foreach($class in $classes)
    {
        Write-Host ("Inspecting class: " + $class.Name)
        Write-Host ("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        
        
        $methods = $class.GetMethods()

        foreach($method in $methods)
        {
            # Finding test methods from assembly
            if (($method.CustomAttributes.Count -gt 0) -and  ($method.CustomAttributes.AttributeType.Name.Contains("TestMethodAttribute")))
            {
                Write-Host ("Test Method found: " + $method.Name)

                # Finding the test case id of test method from properties
                if (($method.CustomAttributes.AttributeType.Name.Contains("TestPropertyAttribute")) -and ($method.CustomAttributes.Where({$_.AttributeType.Name -eq "TestPropertyAttribute"}).ConstructorArguments[0].Value -eq "TestcaseID"))
                {
                    $testCaseId = $method.CustomAttributes.Where({$_.AttributeType.Name -eq "TestPropertyAttribute"}).ConstructorArguments[1].Value
                    Write-Host ("TestcaseID:" + $testCaseId + " is found for Test Method: " + $method.Name)

                    $Uri = $baseDevOpsUrl + $teamProject +'/_apis/wit/workitems/' + $testCaseId + '?fields=System.Description,System.Tags&api-version=' + $apiVersion
                    $testCase = Invoke-RestMethod -Method Get -ContentType application/json -Uri $Uri -Headers $header

                    $testcaseTags = $testCase.fields.'System.Tags';
                    $testcaseDescription = $testCase.fields.'System.Description'

                    [System.Collections.ArrayList]$testcaseTagArray=@();
                    if(-not ([System.String]::IsNullOrWhiteSpace($testcaseTags)))
                    {
                        $testcaseTagArray = $testcaseTags.Split("; ",[System.StringSplitOptions]::RemoveEmptyEntries)
                    }

                    Write-Host ("Test case description: {0}" -f $testcaseDescription)
                    $needUpdateToSummary= $false;

                    # Find the summary descriptions from docs
                    if ($assemblyDocument.doc.members.ChildNodes.Name.Contains(('M:' + $method.DeclaringType.FullName + "." + $method.Name)))
                    {
                       $testMethodBlock = $assemblyDocument.doc.members.ChildNodes.Where({$_.Name -eq ('M:' + $method.DeclaringType.FullName + "." + $method.Name)})
                       $testCaseSummary = $testMethodBlock.summary
                       

                       if($testCaseSummary.GetType().Name -eq 'XmlElement')
                       {
                            $testCaseSummary = $testCaseSummary.InnerXML;
                            $testCaseSummary = FormatSummary -summaryText $testCaseSummary

                       }

                       $testCaseRemarks = $testMethodBlock.remarks

                       if(($testCaseRemarks -ne $null) -and ($testCaseRemarks.GetType().Name -eq 'XmlElement'))
                       {
                            $testCaseRemarks = $testCaseRemarks.InnerXML;
                            $testCaseRemarks = FormatSummary -summaryText $testCaseRemarks

                       }

                       if (($testCaseRemarks -ne $null) -and ($testCaseRemarks.Length -gt 0))
                       {
                            $testCaseSummary = $testCaseSummary + '</br></br><strong>Remarks</strong></br>' + $testCaseRemarks
                       }

                       Write-Host ("Found Test Case Summary: " + $testCaseSummary + ". Processing...")
                      
                        if ((([System.String]::IsNullOrEmpty($testcaseDescription)) -and (-not ([System.String]::IsNullOrEmpty($testCaseSummary)))) -or ($testcaseDescription.Trim() -ne $testCaseSummary))
                        {
                            $testcaseDescription = $testCaseSummary;
                            $needUpdateToSummary= $true;
                            Write-Host ("Test Case Summary is changed marking it for update...")   
                        }
                                            
                    }
                    Write-Host ("------------------------------------------------------------------")
                    Write-Host ("Test case tags: {0}" -f $testcaseTags)

                    $needUpdateToTags = $false;
                    [System.Collections.ArrayList]$testCategoriesInCode=@();

                    # Find any test category attributes if any
                    if ($method.CustomAttributes.AttributeType.Name.Contains("TestCategoryAttribute"))
                    {
                       $testCategoryAtributes = $method.CustomAttributes.Where({$_.AttributeType.Name -eq "TestCategoryAttribute"});

                       foreach($testCategoryAtribute in $testCategoryAtributes)
                       {
                            $testCategory = $testCategoryAtribute.ConstructorArguments[0];
                            Write-Host ("Found Test Category: " + $testCategory.Value + ". Processing...")
                            
                            $tempTestCategoryTag = $testCategoryTagPrefix + $testCategory.Value

                            $testCategoriesInCode.Add($tempTestCategoryTag);

                            if (-not($testcaseTagArray.Contains($tempTestCategoryTag)))
                            {
                                $needUpdateToTags = $true;
                                $testcaseTagArray.Add($tempTestCategoryTag);

                                Write-Host ("Test Category: " + $testCategory + " is new. Marking it to add as tag to the test case...")
                            }
                       }
                    }                    

                    # Filter exisitng test category tags
                    [System.Collections.ArrayList]$existingTestCategoryTags=@();
                    if ($testcaseTagArray.Where({$_ -like "$testCategoryTagPrefix*"}).Count -gt 0)
                    {
                        $existingTestCategoryTags = $testcaseTagArray.Where({$_ -like "$testCategoryTagPrefix*"})
                    }

                    

                    # Identify test categories to be removed and remove them
                    foreach($existingTestCategoryTag in $existingTestCategoryTags)
                    {
                        if (-not($testCategoriesInCode.Contains($existingTestCategoryTag)))
                        {
                            $needUpdateToTags = $true;
                            $testcaseTagArray.Remove($existingTestCategoryTag);

                            Write-Host ("Test Category for tag: " + $existingTestCategoryTag + " is not found in code. Marking it to be removed from tags of the test case...")
                        }
                    }
                    Write-Host ("------------------------------------------------------------------")

                    $updateJSONBody = '[
                        {
                        "op": "test",
                        "path": "/rev",
                        "value": '+ $testCase.rev + '
                        }';
                              
                    if ($needUpdateToTags)
                    {
                        $testCaseTagsToUpdate='';
                        foreach($testcaseTagItem in $testcaseTagArray)
                        {
                            $testCaseTagsToUpdate = $testCaseTagsToUpdate + '; ' + $testcaseTagItem
                        }
                                
                        $testCaseTagsToUpdate = $testCaseTagsToUpdate.Substring(2);

                        $updateJSONBody = $updateJSONBody + ',
                            {
                            "op": "add",
                            "path": "/fields/System.Tags",
                            "value": "'+ $testCaseTagsToUpdate + '"
                            }';

                        Write-Host ("updating test case tags...")
                    }
                              
                    if ($needUpdateToSummary)
                    {
                        $updateJSONBody = $updateJSONBody + ',
                        {
                        "op": "add",
                        "path": "/fields/System.Description",
                        "value": "' + $testcaseDescription + '"
                        }' ;                           
                        Write-Host ("updating test case summary...")          
                    }

                    $updateJSONBody = $updateJSONBody + ']';
                    if ($needUpdateToTags -or $needUpdateToSummary)
                    {
                        $Uri = $baseDevOpsUrl + $teamProject +'/_apis/wit/workitems/' + $testCaseId + '?api-version=' + $apiVersion
                        $response = Invoke-RestMethod -Method Patch -ContentType application/json-patch+json  -Body $updateJSONBody -Uri $Uri -Headers $header
                        
                        Write-Host ("Test case updated successfully")           
                    }


                }
                else
                {
                    Write-Host ("##vso[task.logissue type=warning;]Test Method: " + $method.Name + " has not been defined with Test Property Attribute TestcaseID")
                }
            }
            Write-Host ("==================================================================")
        }
        Write-Host ("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    }
}