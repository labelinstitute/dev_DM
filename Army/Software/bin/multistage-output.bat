REM batch driver file for multistage output service
REM $Id: multistage-output.bat 919 2006-11-02 18:31:58Z wmyuan $

@echo off


set LIBDIR=..\lib
set BINDIR=..\bin


:checkJava
if "%JAVACMD%" == "" set JAVACMD=java
set LOCALCLASSPATH="%CLASSPATH%"
for %%i in ("%LIBDIR%\*.jar") do call "%BINDIR%\lcp.bat" "%%i"


:run
%JAVACMD% -classpath %LOCALCLASSPATH%;. edu.caltech.ssel.multistage.server.util.outputservice.xml.XMLOutputBuilder %1 %2 %3 %4
goto end


:end
set LOCALCLASSPATH=
set BINDIR=
set LIBDIR=


