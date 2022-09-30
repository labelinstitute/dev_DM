REM batch driver script for multistage server
REM $Id: server-multistage.bat 675 2004-02-05 18:12:52Z miao $

@echo off


set LIBDIR=..\lib
set BINDIR=..\bin
set CONFDIR=..\conf
set log4j.configuration=%CONFDIR%\log4j.properties


:checkJava
if "%JAVACMD%" == "" set JAVACMD=java
set LOCALCLASSPATH="%CLASSPATH%"
for %%i in ("%LIBDIR%\*.jar") do call "%BINDIR%\lcp.bat" "%%i"
REM for /f "delims=|" %%f in ('dir /b /s ..\plugins\*.jar') do echo %%f
for /f "delims=|" %%f in ('dir /b /s ..\plugins\*.jar') do call "%BINDIR%\lcp.bat" "%%f"

:run
%JAVACMD% -classpath %LOCALCLASSPATH%;%CONFDIR%;. -Dprop.home=%CONFDIR% edu.caltech.ssel.multistage.server.StartServer
goto end


:end
set LOCALCLASSPATH=
set BINDIR=
set LIBDIR=

pause

