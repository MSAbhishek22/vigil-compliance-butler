# Vigil Setup Guide

## Step 1: Install Prerequisites

### Docker Desktop (Required for PostgreSQL)
Download and install from: https://www.docker.com/products/docker-desktop/

After installation:
1. Launch Docker Desktop
2. Wait for it to fully start (whale icon should be stable)
3. Run: `docker --version` to verify

### Flutter SDK
If not already installed:
```powershell
# Using Chocolatey
choco install flutter

# Or download from https://flutter.dev/docs/get-started/install/windows
```

### Serverpod CLI
```powershell
dart pub global activate serverpod_cli
```

## Step 2: Start Database

```powershell
cd "c:\Users\msabh\OneDrive\Desktop\Vigil (The High-Stakes Compliance Butler)"
docker-compose up -d
```

This starts PostgreSQL on port 5432.

## Step 3: Generate Serverpod Code

```powershell
cd vigil_server
serverpod generate
```

This creates:
- Type-safe model classes from .spy.yaml files
- Client library in vigil_client/
- Database migration scripts

## Step 4: Apply Database Migrations

```powershell
cd vigil_server
dart bin/main.dart --apply-migrations
```

## Step 5: Start the Server

```powershell
cd vigil_server
dart bin/main.dart
```

You should see:
```
╔══════════════════════════════════════════════════════════════╗
║   🎩 VIGIL - The Compliance Butler                          ║
║   Server is now running and vigilant.                        ║
╚══════════════════════════════════════════════════════════════╝
```

## Step 6: Run the Flutter App

```powershell
cd vigil_flutter
flutter pub get
flutter run -d windows  # Or -d chrome for web
```

## Troubleshooting

### "dart: command not found"
Add Flutter/Dart to your PATH:
```powershell
$env:PATH += ";C:\flutter\bin"
```

### "Docker not running"
Start Docker Desktop and wait for it to initialize.

### Database connection failed
Check that PostgreSQL is running:
```powershell
docker ps
```

### Port already in use
Change ports in `vigil_server/config/development.yaml`
