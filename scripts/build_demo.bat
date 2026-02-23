@echo off
REM ========================================
REM Build Script - Demo Delivery
REM ========================================

echo.
echo ====================================
echo   Building DEMO DELIVERY
echo ====================================
echo.

REM Limpar build anterior
echo [1/5] Limpando build anterior...
call flutter clean
if %errorlevel% neq 0 exit /b %errorlevel%

echo.
echo [2/5] Baixando dependencias...
call flutter pub get
if %errorlevel% neq 0 exit /b %errorlevel%

echo.
echo [3/5] Building Android APK...
call flutter build apk --dart-define=ENV=demo --build-name=1.0.0 --build-number=1
if %errorlevel% neq 0 exit /b %errorlevel%

echo.
echo [4/5] Building Android App Bundle...
call flutter build appbundle --dart-define=ENV=demo --build-name=1.0.0 --build-number=1
if %errorlevel% neq 0 exit /b %errorlevel%

echo.
echo ====================================
echo   BUILD COMPLETO!
echo ====================================
echo.
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo AAB: build\app\outputs\bundle\release\app-release.aab
echo.
echo Proximos passos:
echo 1. Testar o APK no dispositivo
echo 2. Upload do AAB para Google Play Console
echo.

pause

