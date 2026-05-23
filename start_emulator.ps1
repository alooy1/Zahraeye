$avdHome = "$env:USERPROFILE\.android\avd"
$env:ANDROID_AVD_HOME = $avdHome
& "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe" -avd Pixel8Test -no-window -no-audio -no-boot-anim
