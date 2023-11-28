@echo on

set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"
if "%blas_impl%" == "openblas" (
    set "BLAS=openblas"
)
else (
    set "BLAS=mkl-sdl"
)

mkdir builddir
"%PYTHON%" -m build --wheel --no-isolation --skip-dependency-check ^
    -Cbuilddir=builddir ^
    -Csetup-args=-Dallow-noblas=false ^
    -Csetup-args=-Dblas=%BLAS% ^
    -Csetup-args=-Dlapack=%BLAS%
if errorlevel 1 (
  type builddir\meson-logs\meson-log.txt
  exit /b 1
)

:: `pip install dist\numpy*.whl` does not work on windows,
:: so use a loop; there's only one wheel in dist/ anyway
for /f %%f in ('dir /b /S .\dist') do (
    pip install %%f
    if %ERRORLEVEL% neq 0 exit 1
)

XCOPY %RECIPE_DIR%\f2py.bat %SCRIPTS% /s /e
if errorlevel 1 exit 1

del %SCRIPTS%\f2py.exe
if errorlevel 1 exit 1