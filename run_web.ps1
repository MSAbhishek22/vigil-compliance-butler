$env:Path = "C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin;$env:LOCALAPPDATA\Pub\Cache\bin;" + $env:Path
Write-Host "🚀 Launching Vigil Web Interface..."
cd vigil_flutter
flutter run -d chrome
Read-Host "Press Enter to exit..."
