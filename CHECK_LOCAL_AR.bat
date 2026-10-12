@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; foreach($u in @('http://127.0.0.1:8000/health','http://127.0.0.1:8000/api/status','http://127.0.0.1:8080/')) { try { $r=Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 $u; Write-Host ('OK  ' + $r.StatusCode + '  ' + $u) -ForegroundColor Green } catch { Write-Host ('FAIL  ' + $u + ' :: ' + $_.Exception.Message) -ForegroundColor Red } }"
echo.
echo إذا ظهر FAIL، شغّل start_windows.bat واترك نوافذ الخادم مفتوحة.
pause
