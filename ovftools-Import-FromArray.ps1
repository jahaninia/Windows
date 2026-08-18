$ErrorActionPreference = "Stop"

# تنظیمات ثابت هاست و دیت‌استور
$OVFTOOL_PATH = "C:\Program Files\VMware\VMware OVF Tool\ovftool.exe"
$datastore    = "datastore1"
$VCENTER_URL  = "vi://root:Test!123@192.168.97.130/"

# آرایه ماشین‌های مجازی (Name و Source)
$vmDeployList = @(
    @{ Name = "Telc-Universe-Elasticsearch2"; Source = "E:\Asiatech\Universe-ELK.ova" },
    @{ Name = "Telc-Universe-Log Pipeline1";  Source = "E:\Asiatech\Universe-ELK.ova" },
    @{ Name = "Telc-Universe-Call2";          Source = "E:\Asiatech\Universe-Call.ova" },
    @{ Name = "Telc-Universe-Call3";          Source = "E:\Asiatech\Universe-Call.ova" },
    @{ Name = "Telc-Universe-ConfigDB2";      Source = "E:\Asiatech\ConfigDB1\ConfigDB1.ovf" },
    @{ Name = "Telc-Universe-Redis1";         Source = "E:\Asiatech\Universe-Module.ova" },
    @{ Name = "Telc-Universe-Redis2";         Source = "E:\Asiatech\Universe-Module.ova" },
    @{ Name = "Telc-Universe-Redis3";         Source = "E:\Asiatech\Universe-Module.ova" }
)

Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "Starting Deployment of $($vmDeployList.Count) VMs sequentially..." -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow

$index = 1
foreach ($vm in $vmDeployList) {

    if (-not (Test-Path -Path $vm.Source)) {
        Write-Host "[-] Error: Source file not found: $($vm.Source)" -ForegroundColor Red
        Write-Host "[-] Aborting process." -ForegroundColor Red
        break
    }

    Write-Host "`n[$index/$($vmDeployList.Count)] Deploying: $($vm.Name)" -ForegroundColor Cyan
    Write-Host "Source: $($vm.Source)" -ForegroundColor Gray

    & $OVFTOOL_PATH `
        "--datastore=$datastore" `
        "--name=$($vm.Name)" `
        "--acceptAllEulas" `
        "--noSSLVerify" `
        "$($vm.Source)" `
        "$VCENTER_URL"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "عملیات موفق بود: $($vm.Name)" -ForegroundColor Green
    } else {
        Write-Host "خطا در Import کردن $($vm.Name). کد خطا: $LASTEXITCODE" -ForegroundColor Red
        break
    }

    $index++
}

Write-Host "`n==========================================" -ForegroundColor Yellow
Write-Host "Deployment cycle finished." -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
