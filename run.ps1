# Automation Script to run Vigil

Write-Host "Starting Vigil Server..."
Start-Process -FilePath "powershell" -ArgumentList "-NoExit -Command cd vigil_server; dart run bin/main.dart"

Write-Host "Waiting for server to initialize..."
Start-Sleep -Seconds 5

Write-Host "Starting Vigil Client..."
Start-Process -FilePath "powershell" -ArgumentList "-NoExit -Command cd vigil_flutter; flutter run -d windows"

Write-Host "Vigil is running! Check the new windows."
