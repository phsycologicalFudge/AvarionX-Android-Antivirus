@echo off
setlocal

cd /d "%~dp0"

py -m PyInstaller rtpModule.py ^
  --onefile ^
  --noconsole ^
  --name rtpModule ^
  --add-binary "assets\vx_titanium.dll;."

if not exist "..\compiled" (
  mkdir "..\compiled"
)

copy /Y "dist\rtpModule.exe" "..\compiled\rtpModule.exe"

echo Build complete.
echo Output: ..\compiled\rtpModule.exe

pause
endlocal
