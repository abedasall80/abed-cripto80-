@echo off
setlocal
cd /d "%~dp0"
where py >nul 2>nul
if errorlevel 1 (
 echo لم يتم العثور على Python Launcher.
 echo ثبّت Python 3.11 أو أحدث من python.org، مع تفعيل Add Python to PATH.
 pause
 exit /b 1
)
if not exist ".venv\Scripts\python.exe" (
 echo إنشاء بيئة Python مستقلة للمشروع...
 py -3 -m venv .venv
 if errorlevel 1 goto :fail
)
echo تحديث pip...
".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 goto :fail
echo تثبيت متطلبات الخادم والاختبارات...
".venv\Scripts\python.exe" -m pip install -r python_engine\requirements.txt pytest
if errorlevel 1 goto :fail
echo فحص صياغة ملفات Python...
".venv\Scripts\python.exe" -m py_compile python_engine\app.py python_engine\quant_engine\indicators.py
if errorlevel 1 goto :fail
echo تشغيل اختبارات المشروع...
".venv\Scripts\python.exe" -m pytest -q
if errorlevel 1 goto :fail
echo.
echo اكتمل الإعداد وفحص الاختبارات. شغّل start_windows.bat.
pause
exit /b 0
:fail
echo.
echo تعذر إكمال الإعداد. اقرأ آخر رسالة خطأ ظاهرة وتأكد من اتصال الإنترنت.
pause
exit /b 1
