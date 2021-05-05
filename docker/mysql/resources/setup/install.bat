@echo off
echo Starting Windows Management Service...
net start winmgmt

echo Running Connect Silent Installer, this will take a while...
%~dp0preinstall.exe

if errorlevel 10 goto err_installer
if errorlevel 2 goto err_unknown
if errorlevel 1 goto err_preinstall

echo Connect installed successfully. Wait for docker to finish...
sc config olconnect_mysql start=demand
goto:eof

:err_installer
echo Installer error - see OL_Install_<timestamp>.log
goto:eof

:err_unknown
echo Unknown preinstall error - see preinstall_err.log
goto:eof

:err_preinstall
echo Preinstall error - see preinstall_err.log
goto:eof