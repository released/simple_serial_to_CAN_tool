@echo off
setlocal
set "BUILD_DIR=%~dp0..\build"

if not exist "%BUILD_DIR%" (
  mkdir "%BUILD_DIR%"
  if errorlevel 1 exit /b %errorlevel%
)

for /d %%D in ("%BUILD_DIR%\*") do (
  if /i not "%%~nxD"==".git" (
    rmdir /s /q "%%~fD"
  )
)

for %%F in ("%BUILD_DIR%\*") do (
  if /i not "%%~nxF"==".gitkeep" if /i not "%%~nxF"=="README.md" (
    del /f /q "%%~fF"
  )
)

echo Clean complete. Preserved: build\README.md, build\.gitkeep
endlocal
