#Requires -Version 7.1
$ErrorActionPreference = "Stop" # exit when command fails

# set script variables
$LV_BRANCH = $LV_BRANCH ?? "master"
$LV_REMOTE = $LV_REMOTE ??  "rand0me/SolarVim.git"
$INSTALL_PREFIX = $INSTALL_PREFIX ?? "$HOME\.local"

$env:XDG_DATA_HOME = $env:XDG_DATA_HOME ?? $env:APPDATA
$env:XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME ?? $env:LOCALAPPDATA
$env:XDG_CACHE_HOME = $env:XDG_CACHE_HOME ?? $env:TEMP

$env:LUNARVIM_RUNTIME_DIR = $env:LUNARVIM_RUNTIME_DIR ?? "$env:XDG_DATA_HOME\solarvim"
$env:LUNARVIM_CONFIG_DIR = $env:LUNARVIM_CONFIG_DIR ?? "$env:XDG_CONFIG_HOME\solarvim"
$env:LUNARVIM_CACHE_DIR = $env:LUNARVIM_CACHE_DIR ?? "$env:XDG_CACHE_HOME\solarvim"
$env:LUNARVIM_BASE_DIR = $env:LUNARVIM_BASE_DIR ?? "$env:LUNARVIM_RUNTIME_DIR\solarvim"

$__lvim_dirs = (
    $env:LUNARVIM_BASE_DIR,
    $env:LUNARVIM_RUNTIME_DIR,
    $env:LUNARVIM_CONFIG_DIR,
    $env:LUNARVIM_CACHE_DIR
)

function main($cliargs) {
    Write-Output "Removing SolarVim binary..."
    remove_lvim_bin
    Write-Output "Removing SolarVim directories..."
    $force = $false
    if ($cliargs.Contains("--remove-backups")) {
        $force = $true
    }
    remove_lvim_dirs $force
    Write-Output "Uninstalled SolarVim!"
}

function remove_lvim_bin(){
    $solarvim_bin="$INSTALL_PREFIX\bin\solarvim.ps1"
    if (Test-Path $solarvim_bin) {
        Remove-Item -Force $solarvim_bin
    }
    if (Test-Path alias:solarvim) {
        Write-Warning "Please make sure to remove the 'solarvim' alias from your `$PROFILE`: $PROFILE"
    }
}

function remove_lvim_dirs($force) {
    foreach ($dir in $__lvim_dirs) {
        if (Test-Path $dir) {
            Remove-Item -Force -Recurse $dir
        }
        if ($force -eq $true) {
            if (Test-Path "$dir.bak") {
                Remove-Item -Force -Recurse "$dir.bak"
            }
            if (Test-Path "$dir.old") {
                Remove-Item -Force -Recurse "$dir.old"
            }
        }
    }
}

main($args)
