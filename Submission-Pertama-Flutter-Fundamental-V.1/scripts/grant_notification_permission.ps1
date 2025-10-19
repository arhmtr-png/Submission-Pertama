param(
    [Parameter(Mandatory=$false)]
    [string]$package,
    [switch]$Restart
)

function Test-Adb {
    $adb = Get-Command adb -ErrorAction SilentlyContinue
    if (-not $adb) {
        Write-Error "adb not found on PATH. Please install Android Platform Tools and ensure adb is on PATH."
        exit 2
    }
    return $adb.Path
}

function Get-Device {
    $out = & adb devices | Select-String -Pattern "\tdevice$" -SimpleMatch
    if (-not $out) {
        Write-Error "No connected device/emulator found. Ensure a device is connected and adb is authorized."
        exit 3
    }
    # Return first device id
    $first = (adb devices | Where-Object { $_ -match "^(.+)\tdevice$" } | ForEach-Object { ($_ -split "\t")[0] })[0]
    return $first
}

# Helper to detect package name from the project files. This script
# is expected to live in the repo's `scripts/` folder; detection will
# handle that by resolving paths relative to the script location.
function Get-PackageFromGradle {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $gradlePath = Join-Path $scriptDir '..\android\app\build.gradle.kts'
    $gradleFile = Resolve-Path -Path $gradlePath -ErrorAction SilentlyContinue
    if (-not $gradleFile) { return $null }
    $content = Get-Content $gradleFile -Raw
    if ($content -match 'applicationId\s*=\s*"([^"]+)"') {
        return $matches[1]
    }
    return $null
}

function Get-PackageFromManifest {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $manifestPath = Join-Path $scriptDir '..\android\app\src\main\AndroidManifest.xml'
    $manifestFile = Resolve-Path -Path $manifestPath -ErrorAction SilentlyContinue
    if (-not $manifestFile) { return $null }
    $xml = Get-Content $manifestFile -Raw
    if ($xml -match 'package="([^"]+)"') {
        return $matches[1]
    }
    return $null
}

try {
    $adb = Test-Adb
    $device = Get-Device
    Write-Host "Using device: $device"

    if (-not $package) {
        Write-Host "Package not provided; attempting to detect package name from project files..."
        $detected = Get-PackageFromGradle
        if ($detected) {
            Write-Host "Detected package from Gradle: $detected"
            $package = $detected
        } else {
            $detected = Get-PackageFromManifest
            if ($detected) {
                Write-Host "Detected package from AndroidManifest: $detected"
                $package = $detected
            }
        }
        if (-not $package) {
            Write-Warning "Could not detect package name automatically. Please pass -package '<your.package.id>'"
            exit 4
        }
    }

    # Grant the POST_NOTIFICATIONS permission (Android 13+)
    $perm = "android.permission.POST_NOTIFICATIONS"
    Write-Host "Granting $perm to $package"
    $cmd = "adb -s $device shell pm grant $package $perm"
    Write-Host $cmd
    & adb -s $device shell pm grant $package $perm
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Grant command returned non-zero exit code. The device may not allow granting runtime permissions via adb on this Android version."
    } else {
        Write-Host "Permission grant attempted. Verify on the device that notifications are allowed for the app."
        if ($Restart.IsPresent) {
            Write-Host "Restart flag set: restarting app $package"
            & adb -s $device shell am force-stop $package
            Start-Sleep -Seconds 1
            # Start the app using monkey; this is a simple way to launch the main activity
            & adb -s $device shell monkey -p $package -c android.intent.category.LAUNCHER 1
            Write-Host "Restart command issued."
        }
    }
} catch {
    Write-Error "An unexpected error occurred: $_"
    exit 5
}
