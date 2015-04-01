::Logic for nabs
::set /P d="Enter disk letter with the game folder"
::set /P version="Enter the correct game folder name if it is in the root directory if it is not put the path without opening & closing slashes."

::Variables
set version=Trunk
set d=D

::Tools prepearing
cd D:\Tools\SVN_Tools\
svn up
MD D:\AutoTestResults\

::Auto tests bin
::D:\Tools\SVN_Tools\Builds\VehArmorCheck\VehArmorCheck.exe D:\%version%\tankfield\res D:\AutoTestResults\armor.log
::D:\Tools\SVN_Tools\Builds\TanksmenCheck\TanksmenCheck.exe D:\%version%\tankfield\res D:\AutoTestResults\tanksmen.log
::D:\Tools\SVN_Tools\Builds\GunModelDuplicateCheck\GunModelDuplicateCheck.exe D:\%version%\tankfield\res D:\AutoTestResults\gundupl.log
::D:\Tools\SVN_Tools\Builds\EmblemsCheck\EmblemsCheck.exe D:\%version%\tankfield\res D:\AutoTestResults\embl.log
::D:\Tools\SVN_Tools\Builds\ChassisSoundCheck\ChassisSoundCheck.exe D:\%version%\tankfield\res D:\AutoTestResults\chsound.log
D:\Tools\SVN_Tools\Builds\CamouflageCheck\CamouflageCheck.exe D:\%version%\tankfield\res D:\AutoTestResults\camocheck.log

::Development modules, etc.
::grep -r "test." %d%:\%version%\tankfield\res\scripts\item_defs\vehicles > D:\AutoTestResults\testmodules.txt
::grep -r "development" %d%:\%version%\tankfield\res\scripts\item_defs\vehicles >> %d%:\AutoTestResults\testmodules.txt
::grep -r "Development" %d%:\%version%\tankfield\res\scripts\item_defs\vehicles >> %d%:\AutoTestResults\testmodules.txt

::Carbage search
::grep -r "<pitchLimits> -90 90 </pitchLimits>" %d%:\%version%\tankfield\res\scripts\item_defs\vehicles > %d%:\AutoTestResults\testmodules\pitchLimits.txt
::grep -r "train" %d%:\%version%\tankfield\res\scripts\item_defs\vehicles > %d%:\AutoTestResults\testmodules\train_modules.txt ::Think how to find the modules with no NotInShop
::grep -r "<Bool/>alphaTestEnable" %d%:\%version%\tankfield\res\vehicles > %d%:\AutoTestResults\testmodules\tags_in_visual_files.txt
::grep -r "<turretYawLimits>-180 180</turretYawLimits>" %d%:\%version%\tankfield\res\scripts\item_defs\vehicles > %d%:\AutoTestResults\testmodules\pitchLimits.txt

::Search of non-closed tags in scripts
::grep -r "<([A-Z][A-Z0-9]*)[^>]*>\s*</\1>" %d%:\%version%\tankfield\res\scripts\item_defs\vehicles > %d%:\AutoTestResults\not_closed_tags_cont.txt

::Search of non-closed tags in content
::grep -r "<([A-Z][A-Z0-9]*)[^>]*>\s*</\1>" %d%:\%version%\tankfield\res\vehicles > %d%:\AutoTestResults\not_closed_tags_cont.txt

:: WOTA-32711 Search of *.model files with duplicated 
::for /R "%d%:\%version%\tankfield\res\vehicles" %%i in (*.model) do (
::echo %%i >> %d%:\AutoTestResults\model_files_check\dups2.txt 
::sort "%%i" | uniq -d >> %d%:\AutoTestResults\model_files_check\dups2.txt
::grep -v "D:\" %d%:\AutoTestResults\model_files_check\dups2.txt >> no_ways.txt)

:: WOTA-32711 Search of *.visual files with duplicated 
::for /R "%d%:\%version%\tankfield\res\vehicles" %%i in (*.visual) do (
::echo %%i >> %d%:\AutoTestResults\visual_files_check\dups2.txt 
::sort "%%i" | uniq -d >> %d%:\AutoTestResults\visual_files_check\dups2.txt
::grep -v "D:\" %d%:\AutoTestResults\visual_files_check\dups2.txt >> no_ways.txt)

::Project of making .pkg files
::cd %d%:\%version%\bigworld\tools\misc\res_packer\
::%d%:\%version%\bigworld\tools\misc\res_packer\bin_convert.py --res "D:\%version%\bigworld\res;D:\%version%\tankfield\res" "D:\Trunk\tankfield\res\vehicles\german\G30_Pz_KV-1_756" "D:\%version%\game_release_pkg\res\vehicles\german\G30_Pz_KV-1_756"

PAUSE