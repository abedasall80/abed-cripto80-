@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
 echo لم يتم تجهيز البيئة بعد. شغّل setup_windows.bat أولاً.
 pause
 exit /b 1
)
REM Check whether API port is already responding; otherwise start the API.
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r=Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://127.0.0.1:8000/health; exit 0 } catch { exit 1 }" >nul 2>nul
if errorlevel 1 (
 start "AbuAlAsal Python API" /D "%~dp0python_engine" "%~dp0.venv\Scripts\python.exe" -m uvicorn app:app --host 127.0.0.1 --port 8000
) else (
 echo خادم Python يعمل مسبقًا على المنفذ 8000.
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r=Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://127.0.0.1:8080/; exit 0 } catch { exit 1 }" >nul 2>nul
if errorlevel 1 (
 start "AbuAlAsal Frontend" /D "%~dp0" "%~dp0.venv\Scripts\python.exe" -m http.server 8080 --bind 127.0.0.1 --directory "%~dp0site"
) else (
 echo خادم الواجهة يعمل مسبقًا على المنفذ 8080.
)
timeout /t 3 >nul
echo.
echo =============================================
echo   AbuAlAsal Quant Fusion AI PRO - تشغيل محلي
echo =============================================
echo الواجهة:      http://127.0.0.1:8080
echo فحص Python:   http://127.0.0.1:8000/health
echo توثيق API:    http://127.0.0.1:8000/docs
echo حالة API:     http://127.0.0.1:8000/api/status
echo.
start "" "http://127.0.0.1:8080"
echo اترك نافذتي الخادم مفتوحتين أثناء التجربة.
pause
