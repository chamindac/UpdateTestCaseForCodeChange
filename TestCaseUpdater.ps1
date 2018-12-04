$folderPath = $env:TestAssemblyPath;
$testAssemblyFilter = $env:TestAssemblyFilePattern;

$testAssemblies = (Get-ChildItem -Path $folderPath -Recurse -Filter $testAssemblyFilter).FullName

foreach($testAssembly in $testAssemblies)
{
    Write-Host ("******************************************************************")
    Write-Host ("Test assembly found: " + $testAssembly)
    Write-Host ("------------------------------------------------------------------")

    $asm = [System.Reflection.Assembly]::LoadFrom($testAssembly)

    $testDocumentationFilePath = $testAssembly -replace ".dll",".xml"
    [xml]$assemblyDocument = Get-Content -Path $testDocumentationFilePath
    
    $classes =  $asm.GetTypes()
    foreach($class in $classes)
    {
        Write-Host ("Inspecting class: " + $class.Name)
        Write-Host ("------------------------------------------------------------------")
        
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

                    # Find any test category attributes if any
                    if ($method.CustomAttributes.AttributeType.Name.Contains("TestCategoryAttribute"))
                    {
                       $testCategoryAtributes = $method.CustomAttributes.Where({$_.AttributeType.Name -eq "TestCategoryAttribute"});

                       foreach($testCategoryAtribute in $testCategoryAtributes)
                       {
                            $testCategory = $testCategoryAtribute.ConstructorArguments[0];
                            Write-Host ("Found Test Category: " + $testCategory + ". Adding to tags of test case ...")
                       }
                    }
                    if ($assemblyDocument.doc.members.ChildNodes.Name.Contains(('M:' + $method.DeclaringType.FullName + "." + $method.Name)))
                    {
                       $testCaseSummary = $assemblyDocument.doc.members.ChildNodes.Where({$_.Name -eq ('M:' + $method.DeclaringType.FullName + "." + $method.Name)}).Summary

                       Write-Host ("Found Test Case Summary: " + $testCaseSummary + ". Updating test case ...")
                    }
                }
                else
                {
                    Write-Warning ("Test Method: " + $method.Name + " has not been defined with Test Property Attribute TestcaseID")
                }
            }
        }
        Write-Host ("------------------------------------------------------------------")
    }
}