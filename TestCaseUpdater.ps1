$asm = [System.Reflection.Assembly]::LoadFrom('C:\Chaminda\tmp\drop\Testautomationproj1.dll')
$classes =  $asm.GetTypes()

foreach($class in $classes)
{
    $class.Name
    $methods = $class.GetMethods()
}
