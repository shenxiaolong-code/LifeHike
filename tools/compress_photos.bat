
@echo off
:: call :config %*
call :config_default
if not exist "%INPUT_DIR%" goto :error "input dir is missing"
call :compress_dir
:: if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
call :reset
goto :End

:config_default
call :config "D:\temp\journal" "D:\temp\journal_compressed"
goto :eof 

:config
:: =================config region=================
:: download from: https://imagemagick.org/download/#windows
:: batch compress photos, keep directory structure
:: use ImageMagick to compress
:: compress quality: 75
:: maximum width: 1920
:: input directory example: D:\Photos\Trekking_Raw
:: output directory example: D:\work\LifeHike\Trekking

:: D:\apps\ImageMagick712Q16\magick.exe
where magick.exe 1>nul 2>nul || set "MAGICK_PATH=D:\apps\ImageMagick712Q16"
where magick.exe 1>nul 2>nul || set "path=%MAGICK_PATH%;%path%"
where magick.exe 1>nul 2>nul || goto :error "magick.exe not found"
:: set "INPUT_DIR=D:\Photos\Trekking_Raw"
set "INPUT_DIR=%~1"
:: set "OUTPUT_DIR=D:\work\LifeHike\Trekking"
set "OUTPUT_DIR=%~2"
:: compress quality (1-100)
set "QUALITY=75"
:: maximum width (keep proportion)
set "WIDTH=1920"
:: =========================================
goto :eof

:reset
set "INPUT_DIR="
set "OUTPUT_DIR="
set "QUALITY="
set "WIDTH="
goto :eof

:compress_dir
echo [starting] scanning: "%INPUT_DIR%"
echo [output target] "%OUTPUT_DIR%"
:: traverse all jpg, jpeg, png files in the input directory
for /r "%INPUT_DIR%" %%F in (*.jpg *.jpeg *.png) do call :compress_file "%%F"
goto :eof

:compress_file
:: get relative path, keep directory structure
    call set "FILE_PATH=%~f1"
    call set "REL_PATH=%%FILE_PATH:%INPUT_DIR%\=%%"
    
    :: build target path
    call set "DEST_PATH=%OUTPUT_DIR%\%REL_PATH%"
    
    :: get target folder path and create (if not exist)
    for %%D in ("%DEST_PATH%") do set "DEST_FOLDER=%%~dpD"
    if not exist "%DEST_FOLDER%" (
        echo.
        echo [creating directory] "%DEST_FOLDER%"
        md "%DEST_FOLDER%"
    )

    :: check if file exists, avoid duplicate compression (optional)
    :: echo [compressing] "%REL_PATH%"
    
    :: call ImageMagick to compress
    :: -resize 1920x > shrink only when width is greater than 1920, keep proportion
    :: -quality set compress quality
    call magick.exe "%FILE_PATH%" -resize "%WIDTH%x>" -quality %QUALITY% "%DEST_PATH%"
    call :show_size "%FILE_PATH%" "%DEST_PATH%"
goto :eof

:show_size
set /a rate=(%~z2*100)/%~z1
echo [compressed] "%~f1" =^> "%~f2"  : %~z1 =^> %~z2    : %rate%%%
goto :eof

:error
echo.
echo [error] %~1
pause
goto :eof

:End
echo.
echo [done] all photos are compressed and synchronized to the output directory.
pause