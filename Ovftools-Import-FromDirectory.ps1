# تعریف متغیرها
$OVF_DIR = "E:\Asiatech\"
$OVFTOOL_PATH = "C:\Program Files\VMware\VMware OVF Tool\ovftool.exe"
$VCENTER_URL = "vi://root:Test!123@192.168.97.130/"
$DATASTORE = "datastore1"
$NETWORK = "VM Network"
$prefixName="Telc-"

# چک کردن موجود بودن فایل‌ها
$files = Get-ChildItem -Path $OVF_DIR -Filter *.ova

if ($files.Count -eq 0) {
    Write-Host "هیچ فایل OVF در مسیر پیدا نشد. مسیر رو چک کن." -ForegroundColor Red
    exit
}

foreach ($file in $files) {
    $vmName = $prefixName+$file.BaseName
    Write-Host "در حال Import کردن: $vmName" -ForegroundColor Cyan

    # اجرای دستور ovftool
    & $OVFTOOL_PATH --datastore=$DATASTORE --name=$vmName --network=$NETWORK --acceptAllEulas --noSSLVerify "$($file.FullName)" $VCENTER_URL

    if ($LASTEXITCODE -eq 0) {
        Write-Host "عملیات موفق بود: $vmName" -ForegroundColor Green
    } else {
        Write-Host "خطا در Import کردن $vmName. کد خطا: $LASTEXITCODE" -ForegroundColor Red
    }
}
