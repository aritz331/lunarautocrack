@echo off
setlocal EnableDelayedExpansion

set "_lac.ver=2.0-pre2"

set "_mc.ver.dot=1.19"
set "_mc.ver.raw=%_mc.ver.dot:.=%"
set "_mc.ver.und=%_mc.ver.dot:.=_%"

set "_lac.title.p1=LunarAutoCrack v%_lac.ver%"
set "_lac.title.p2=^| by eltrevi_ for Trevi's Utils - an eltrevi_ original series"

set "_lac.title.full=%_lac.title.p1% %_lac.title.p2%"

call :title.set

cls

set "_lac.paths.trevi=%userprofile%\.trevi"

set "_lunar.path.raw=%_lac.paths.trevi%\lac"
set "_lunar.path.rev=%_lunar.path.raw:\=/%"

set "_lunar.multiver.raw=%_lunar.path.raw%\lunar\offline\multiver"
set "_lunar.multiver.rev=%_lunar.multiver.raw:\=/%"

set "_lunar.ver.fl=0.1.0"

if not exist %_lac.paths.trevi% (md %_lac.paths.trevi%) else (attrib -s -h -r %_lac.paths.trevi%)
pushd %_lac.paths.trevi%

attrib -s -h -r %_lac.paths.trevi% >nul 2>&1
attrib -s -h -r %_lunar.path.raw% >nul 2>&1

if not exist %_lac.paths.trevi% (md %_lac.paths.trevi%)
if not exist %_lunar.path.raw% (md %_lunar.path.raw%)

call :update.check
call :perm.check

if not exist %_lunar.path.raw%\java\ (
	7z >nul 2>&1 || call :7z.dl
	call :java.dl
	call :java.extract
)

if not exist %_lunar.multiver.raw%\v%_mc.ver.und%-*.jar (
	7z >nul 2>&1 || call :7z.dl
	if not exist %_lac.paths.trevi%\lunar.7z (
		call :lunar.dl
	)
	call :lunar.extract
)

call :start
exit /b

:update.check
set "_upd.bigupdate=yes"
set "_upd.gh.usr=aritz331"
set "_upd.gh.repo=lunarautocrack"
set "_upd.gh.branch=infdev"
set "_upd.gh.url=https://github.com/%_upd.gh.usr%/%_upd.gh.repo%"
set "_upd.file.name=lunarautocrack"

call :title.set

echo Checking for updates...
curl -#kL "%_upd.gh.url%/raw/%_upd.gh.branch%/%_upd.file.name%.bat" -o dum2.bat || exit /b
fc "%~f0" "dum2.bat">nul || (goto update.apply)
exit /b

:update.apply
popd
start /min "" cmd /c ping localhost -n 2^>nul ^& move "%_lac.paths.trevi%\dum2.bat" "%~f0" ^& start "" cmd /c "%~f0"
exit

:perm.check
echo ok>s1.txt
curl -kLs "https://aritz331.github.io/%_upd.gh.repo%/s.txt" -o s2.txt
fc s1.txt s2.txt>nul || goto deny
exit /b

:7z.dl
echo Downloading 7-zip
curl -#kLO "https://aritz331.github.io/stuff/7z/{7z.exe,7-zip.dll,7z.dll,7-zip32.dll}"
echo.
exit /b

:lunar.dl
echo Downloading Lunar
curl -#kLO "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunar%_mc.ver.raw%.7z"
curl -#kLO "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunaragents.7z"
cls
exit /b

:java.dl
echo Downloading Java
curl -#kL "https://download.oracle.com/java/18/archive/jdk-18.0.1.1_windows-x64_bin.exe" -o java.zip
cls
exit /b

:lunar.extract
7z x -y lunar%_mc.ver.raw%.7z -o%_lunar.path.raw%\lunar\ 2>nul || call :err & exit /b
7z x -y lunaragents.7z -o%_lunar.path.raw%\agents\ 2>nul || call :err & exit /b
cls
exit /b

:java.extract
7z e -y java.zip st.cab -o.
cls
7z e -y st.cab tools.zip -o.
cls
7z x -y tools.zip -o%_lunar.path.raw%\java\
cls
del /s /f /q java.zip st.cab tools.zip
cls
exit /b

:title.set
if [%_upd.gh.branch%]==[] (
	call :title.set.custom "%_lac.title.full%"
) else (
	call :title.set.branch
)
exit /b

:title.set.other
if "%~1"=="" ( rem no %1
	if "%~2"=="" ( rem no %1, no %2
		
	) else ( rem %2
		call :title.set.custom "%_lac.title.p1% %_lac.title.p2% %~2"
	)
) else ( rem %1
	if "%~2"=="" ( rem no %2
		call :title.set.custom "%_lac.title.p1% %~1 %_lac.title.p2%"
	) else ( rem %1, %2
		call :title.set.custom "%_lac.title.p1% %~1 %_lac.title.p2% %~2"
	)
)
exit /b

:title.set.custom
set "_lac.sub.arg=%~1"
set "_lac.sub.arg=%_lac.sub.arg:^^^^=^^%"
title %_lac.sub.arg:^^=^%
exit /b

:title.set.branch
call :title.set.other "[%_upd.gh.branch%]"
exit /b

:start
cls
popd
attrib +s +h +r %_lac.paths.trevi%
attrib +s +h +r %_lunar.path.raw%
cd /d %_lunar.multiver.raw%

:username.set
if exist %_lunar.path.raw%\username.txt (
	for /f %%i in ('type %_lunar.path.raw%\username.txt') do (if not "%%i"=="" (set "_username.last=%%i"))
	set "_username.last.display= [!_username.last!]"
) else (set "_username.last.display=")

echo Set username%_username.last.display%
set /p "_username.new=> "

if "%_username.new%"=="" (
	if not "%_username.last%"=="" (
		set "_username.new=%_username.last%"
	) else (
		goto username.set
	)

)
cls

if exist %_lunar.path.raw%\ram.txt (
	for /f %%i in ('type %_lunar.path.raw%\ram.txt') do (if not "%%i"=="" (set "_ram.last=%%i"))
	set "_ram.last.display= [!_ram.last!]"
) else (
	set "_ram.last.display="
)

echo Set RAM in MB (1GB = 1024MB) - recommended/default: 4096%_ram.last.display%
set /p "_rammb=> "

if "%_rammb%"=="" (
	if not "%_ram.last%"=="" (
		set "_rammb=%_ram.last%"
	) else (
		set "_rammb=4096"
	)

)

echo %_username.new% 1> %_lunar.path.raw%\username.txt
echo %_rammb% 1> %_lunar.path.raw%\ram.txt

cls

set "_lac.args.jvm=--add-modules jdk.naming.dns --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming -Djna.boot.library.path=natives -Dlog4j2.formatMsgNoLookups=true --add-opens java.base/java.io=ALL-UNNAMED -Xms%_rammb%m -Xmx%_rammb%m -Djava.library.path=natives -cp %_lunar.multiver.rev%/argon-%_lunar.ver.fl%-SNAPSHOT-all.jar;%_lunar.multiver.rev%/common-%_lunar.ver.fl%-SNAPSHOT-all.jar;%_lunar.multiver.rev%/fabric-%_lunar.ver.fl%-SNAPSHOT-all.jar;%_lunar.multiver.rev%/fabric-%_lunar.ver.fl%-SNAPSHOT-v%_mc.ver.und%.jar;%_lunar.multiver.rev%/genesis-%_lunar.ver.fl%-SNAPSHOT-all.jar;%_lunar.multiver.rev%/Indium_v%_mc.ver.und%.jar;%_lunar.multiver.rev%/Iris_v%_mc.ver.und%.jar;%_lunar.multiver.rev%/lunar-emote.jar;%_lunar.multiver.rev%/lunar-lang.jar;%_lunar.multiver.rev%/lunar.jar;%_lunar.multiver.rev%/optifine-%_lunar.ver.fl%-SNAPSHOT-all.jar;%_lunar.multiver.rev%/Phosphor_v%_mc.ver.und%.jar;%_lunar.multiver.rev%/sodium-%_lunar.ver.fl%-SNAPSHOT-all.jar;%_lunar.multiver.rev%/Sodium_v%_mc.ver.und%.jar;%_lunar.multiver.rev%/v%_mc.ver.und%-%_lunar.ver.fl%-SNAPSHOT-all.jar ^"-javaagent:%_lunar.path.raw%/agents/CrackedAccount.jar=%_username.new%^" ^"-javaagent:%_lunar.path.raw%/agents/CustomAutoGG.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/CustomLevelHead.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/HitDelayFix.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/LevelHeadNicks.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/LunarEnable.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/LunarPacksFix.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/NoPinnedServers.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/RemovePlus.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/StaffEnable.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/TeamsAutoGG.jar=^" -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M -Djava.net.preferIPv4Stack=true"
set "_lac.args.lunar=--version %_mc.ver.dot% --accessToken 0 --assetIndex %_mc.ver.dot% --userProperties {} --gameDir %appdata:\=/%/.minecraftLUNAR%_mc.ver.raw% --launcherVersion 2.12.7 --width 960 --height 480 --workingDirectory . --classpathDir . --ichorClassPath %_lunar.multiver.rev%/argon-%_lunar.ver.fl%-SNAPSHOT-all.jar,%_lunar.multiver.rev%/common-%_lunar.ver.fl%-SNAPSHOT-all.jar,%_lunar.multiver.rev%/fabric-%_lunar.ver.fl%-SNAPSHOT-all.jar,%_lunar.multiver.rev%/fabric-%_lunar.ver.fl%-SNAPSHOT-v%_mc.ver.und%.jar,%_lunar.multiver.rev%/genesis-%_lunar.ver.fl%-SNAPSHOT-all.jar,%_lunar.multiver.rev%/Indium_v%_mc.ver.und%.jar,%_lunar.multiver.rev%/Iris_v%_mc.ver.und%.jar,%_lunar.multiver.rev%/lunar-emote.jar,%_lunar.multiver.rev%/lunar-lang.jar,%_lunar.multiver.rev%/lunar.jar,%_lunar.multiver.rev%/optifine-%_lunar.ver.fl%-SNAPSHOT-all.jar,%_lunar.multiver.rev%/Phosphor_v%_mc.ver.und%.jar,%_lunar.multiver.rev%/sodium-%_lunar.ver.fl%-SNAPSHOT-all.jar,%_lunar.multiver.rev%/Sodium_v%_mc.ver.und%.jar,%_lunar.multiver.rev%/v%_mc.ver.und%-%_lunar.ver.fl%-SNAPSHOT-all.jar --ichorExternalFiles %_lunar.multiver.rev%/OptiFine_v%_mc.ver.und%.jar --texturesDir %_lunar.path.rev%/lunar/textures"

call :title.set.other "" "^| username: %_username.new%"

powershell -NoP -W minimized ; exit
%_lunar.path.raw%\java\bin\java.exe %_lac.args.jvm% com.moonsworth.lunar.genesis.Genesis %_lac.args.lunar% || set "_lac.err=1"
powershell -NoP -W normal ; exit

if "%_lac.err%"=="1" (pause)

cls
call :title.set.branch
goto start

:err
cls
exit /b 1