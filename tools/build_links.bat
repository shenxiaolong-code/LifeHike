@echo off
set "trace_dir=%cd%"
if not exist "%trace_dir%\images"       goto :error "incorrect directory"
if not exist "%trace_dir%\readme.md"    goto :error "incorrect directory"
call :update_readme
goto :End

:update_readme
echo updating %trace_dir%\readme.md ...
(
    echo.
    echo.
    echo ___
)>> "%trace_dir%\readme.md"
for /r "%trace_dir%\images" %%F in (*.jpg *.jpeg *.png) do call :embed_link "%%F"
goto :eof

:embed_link
echo ![](./images/%~nx1)
echo ![](./images/%~nx1) >> "%trace_dir%\readme.md"
goto :eof

:error
echo.
echo [error] %*
goto :End

:End
