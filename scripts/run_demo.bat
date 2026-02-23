@echo off
REM ========================================
REM Run Script - Demo Delivery (Development)
REM ========================================

echo.
echo ====================================
echo   Running DEMO DELIVERY
echo ====================================
echo.

REM Verificar se tem dispositivos conectados
echo Verificando dispositivos...
call flutter devices

echo.
echo Escolha o dispositivo:
echo [1] Chrome (Web)
echo [2] Android (Dispositivo conectado)
echo [3] Windows (Desktop)
echo.

set /p choice="Digite sua escolha (1-3): "

if "%choice%"=="1" (
    echo.
    echo Rodando no Chrome...
    call flutter run -d chrome --dart-define=ENV=demo --web-port 3001
) else if "%choice%"=="2" (
    echo.
    echo Rodando no Android...
    call flutter run --dart-define=ENV=demo
) else if "%choice%"=="3" (
    echo.
    echo Rodando no Windows...
    call flutter run -d windows --dart-define=ENV=demo
) else (
    echo Opcao invalida!
    pause
    exit /b 1
)

