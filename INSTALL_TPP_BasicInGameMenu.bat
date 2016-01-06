@ECHO OFF

SET tpp_install_mod_name=BasicInGameMenu
SET tpp_install_data=00
SET tpp_install_file=%tpp_install_mod_name%.lua
SET "tpp_install_file_inf=18e380981eb893ef^|%tpp_install_data%\Assets\tpp\script\lib\%tpp_install_file% key^=0 version^=2 compressed^=0"

if not exist %tpp_install_data%.dat (
echo "%tpp_install_data%.dat was not found. Make sure you move all files and run this file in the C:\Program Files (x86)\Steam\steamapps\common\MGS_TPP\master\0\ folder."
PAUSE
EXIT
)

if not exist "%tpp_install_file%" (
echo "%tpp_install_file% was not found. Make sure you move all files and run this file in the C:\Program Files (x86)\Steam\steamapps\common\MGS_TPP\master\0\ folder."
PAUSE
EXIT
)

MKDIR backup-%tpp_install_mod_name%
COPY %tpp_install_data%.dat backup-%tpp_install_mod_name%

echo "Extracting %tpp_install_data%.dat..."

::TIMEOUT /NOBREAK /t 2

"MGSV_QAR_Tool/MGSV_QAR_Tool.exe" %tpp_install_data%.dat -r

cls

echo "Copying and patching files..."

::TIMEOUT /NOBREAK /t 2

set file_tpp=%tpp_install_data%\Assets\tpp\script\lib\Tpp.lua
set file_tpp_find="/Assets/tpp/script/lib/TppMbFreeDemo.lua"
set file_tpp_replace="/Assets/tpp/script/lib/TppMbFreeDemo.lua","/Assets/tpp/script/lib/%tpp_install_file%"

set file_tppmain=%tpp_install_data%\Assets\tpp\script\lib\TppMain.lua
set file_tppmain_find=TppMission.UpdateForMissionLoad
set file_tppmain_replace=TppMission.UpdateForMissionLoad,%tpp_install_mod_name%.Update

if not exist "%file_tpp%" (
echo "%file_tpp% was not found in %tpp_install_data%. %tpp_install_mod_name% was not installed."
PAUSE
EXIT
)

if not exist "%file_tppmain%" (
echo "%file_tppmain% was not found in %tpp_install_data%. %tpp_install_mod_name% was not installed."
PAUSE
EXIT
)

COPY %tpp_install_file% %tpp_install_data%\Assets\tpp\script\lib

findstr /C:"%tpp_install_file%" %tpp_install_data%.inf
if not %errorlevel%==0 (
echo %tpp_install_file_inf% >> %tpp_install_data%.inf
)

set skip_patch=0

findstr /C:"%tpp_install_file%" %file_tpp%
if %errorlevel%==0 (
cls
echo "Looks like %file_tpp% file patch was already made, skipping..."
::TIMEOUT /NOBREAK /t 2
set skip_patch=1
)

findstr /C:"%tpp_install_mod_name%.Update" %file_tppmain%
if %errorlevel%==0 (
cls
echo "Looks like %file_tppmain% file patch was already made, skipping..."
::TIMEOUT /NOBREAK /t 2
set skip_patch=1
)

if %skip_patch%==1 goto :skip_file_patch

setlocal EnableDelayedExpansion
set "output_cnt=0"
for /F "delims=" %%f in ('type %file_tpp%') do (
    set /a output_cnt+=1
    set "output_tpp[!output_cnt!]=%%f"
)
break>%file_tpp%
for /L %%n in (1 1 !output_cnt!) DO echo !output_tpp[%%n]:%file_tpp_find%=%file_tpp_replace%!>>%file_tpp%

findstr /C:"%tpp_install_file%" %file_tpp%
if %errorlevel%==1 (
echo "File edit made to %file_tpp% was not successful. %tpp_install_mod_name% was not installed."
PAUSE
EXIT
)

set "output_cnt=0"
for /F "delims=" %%f in ('type %file_tppmain%') do (
    set /a output_cnt+=1
    set "output_tppmain[!output_cnt!]=%%f"
)
break>%file_tppmain%
for /L %%n in (1 1 !output_cnt!) DO echo !output_tppmain[%%n]:%file_tppmain_find%=%file_tppmain_replace%!>>%file_tppmain%

findstr /C:"%tpp_install_mod_name%" %file_tppmain%
if %errorlevel%==1 (
echo "File edit made to %file_tppmain% was not successful. %tpp_install_mod_name% was not installed."
PAUSE
EXIT
)

cls

:skip_file_patch

echo "Repacking %tpp_install_data%.dat..."

::TIMEOUT /NOBREAK /t 2

"MGSV_QAR_Tool/MGSV_QAR_Tool.exe" %tpp_install_data%.inf -r

rd %tpp_install_data% /S /Q

cls
echo ==========
echo %tpp_install_mod_name% installed. 
echo ==========
echo - Original %tpp_install_data%.dat has been backed up to backup-%tpp_install_mod_name% folder
echo - To Uninstall mod, restore the %tpp_install_data%.dat from that location
echo ==========
PAUSE
EXIT