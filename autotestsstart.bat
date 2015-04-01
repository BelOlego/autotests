::Logic for nabs
::set /P d="Enter disk letter with the game folder"
::set /P version="Enter the correct game folder name if it is in the root directory if it is not put the path without opening & closing slashes."

::Path to folder with stable version without diskname
set version=0.9.7
::Disk name
set d=D

::Tools updating
cd %d%:\Tools\SVN_Tools\
svn up
cd %d%:\Trunk\bin\tools\TankConfigurator\
svn up

::Paste logic to kill previous results
::Making DIR for test results
MD %d%:\AutoTestResults\

::Auto tests bin
%d%:\Tools\SVN_Tools\Builds\VehArmorCheck\VehArmorCheck.exe %d%:\%version%\res\wot %d%:\AutoTestResults\armor.log
%d%:\Tools\SVN_Tools\Builds\TanksmenCheck\TanksmenCheck.exe %d%:\%version%\res\wot %d%:\AutoTestResults\tanksmen.log
%d%:\Tools\SVN_Tools\Builds\GunModelDuplicateCheck\GunModelDuplicateCheck.exe %d%:\%version%\res\wot %d%:\AutoTestResults\gundupl.log
%d%:\Tools\SVN_Tools\Builds\EmblemsCheck\EmblemsCheck.exe %d%:\%version%\res\wot %d%:\AutoTestResults\embl.log
::Needs to be redesigned - tag name has changed
::%d%:\Tools\SVN_Tools\Builds\ChassisSoundCheck\ChassisSoundCheck.exe %d%:\%version%\res\wot %d%:\AutoTestResults\chsound.log
%d%:\Tools\SVN_Tools\Builds\CamouflageCheck\CamouflageCheck.exe %d%:\%version%\res\wot %d%:\AutoTestResults\camocheck.log

::Development modules, etc.
grep -r "test." %d%:\%version%\res\wot\scripts\item_defs\vehicles > %d%:\AutoTestResults\testmodules.txt
grep -r "development" %d%:\%version%\res\wot\scripts\item_defs\vehicles >> %d%:\AutoTestResults\testmodules.txt
grep -r "Development" %d%:\%version%\res\wot\scripts\item_defs\vehicles >> %d%:\AutoTestResults\testmodules.txt

::Carbage search
grep -r "<pitchLimits> -90 90 </pitchLimits>" %d%:\%version%\res\wot\scripts\item_defs\vehicles > %d%:\AutoTestResults\pitchLimits.txt
grep -r "train" %d%:\%version%\res\wot\scripts\item_defs\vehicles > %d%:\AutoTestResults\train_modules.txt

::Think how to find the modules with no NotInShop
grep -r "<Bool/>alphaTestEnable" %d%:\%version%\res\wot\vehicles > %d%:\AutoTestResults\tags_in_visual_files.txt
grep -r "<turretYawLimits>-180 180</turretYawLimits>" %d%:\%version%\res\wot\scripts\item_defs\vehicles >> %d%:\AutoTestResults\pitchLimits.txt

::Find links to tga
grep -r ".tga" %d%:\%version%\res\wot\vehicles > %d%:\AutoTestResults\links_to_tga.txt

::Find useless offset
grep -r "<offset> 0.000000 </offset>" %d%:\%version%\res\wot\vehicles > %d%:\AutoTestResults\useless_offset.txt

::Checking marksonGun https://jira.wargaming.net/browse/WOTD-28639, in 0.9.1 you need to start it from Trunk
%d%:\Trunk\bin\tools\TankConfigurator\TankConfigurator.exe %d%:\%version%\ Test %d%:\AutoTestResults\marks_on_gun.log Emblems

::Comparing IGR & parent xml files https://jira.wargaming.net/browse/WOTD-39491
%d%:\Trunk\bin\tools\TankConfigurator\TankConfigurator.exe %d%:\%version%\bin\client\win32\paths.xml Test %d%:\AutoTestResults\CheckIgr.log CheckIgr
grep "ERROR" %d%:\AutoTestResults\CheckIgr.log | sort >> %d%:\AutoTestResults\CheckIgr_sorted_errors.log
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
::Closed AODecals slot https://jira.wargaming.net/browse/WOTA-54828
grep -r "<AODecals/>" %d%:\%version%\res\wot\scripts\item_defs\vehicles\ >> %d%:\AutoTestResults\closed_ao_decals_tags.txt

::Find lack of AODecals like in https://jira.wargaming.net/browse/WOTA-54824
grep -rc "AODecals" %d%:\%version%\res\wot\scripts\item_defs\vehicles\ | grep ":0" >> %d%:\AutoTestResults\absence_ao_decals.txt
sed -r -e "/chassis\.xml|chassis_effects\.xml|damage_stickers\.xml|equipments\.xml|exhaust_effects\.xml|engines\.xml|fuelTanks\.xml|guns\.xml|radios\.xml|shells\.xml|turrets\.xml|customization\.xml|list\.xml|vehicle\.xml|player_emblems\.xml|gun_effects\.xml|horns\.xml|optional_devices\.xml|shot_effects\.xml|turret_effects\.xml|vehicle_effects\.xml/d" D:\absence_ao_decals.txt >> %d%:\AutoTestResults\absence_ao_decals_clear.txt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
::Check marks on guns not following the gun after shot
grep -r "<animateEmblemSlots> false </animateEmblemSlots>" %d%:\%version%\res\wot\scripts\item_defs\vehicles\ >> %d%:\AutoTestResults\non_animated_marks_on_guns.txt

::Check bad lods for tracks https://jira.wargaming.net/browse/WOTA-52989
grep -r -A 1 "<tracks>" %d%:\%version%\res\wot\scripts\item_defs\vehicles | grep "<lodDist> MEDIUM </lodDist>" >> %d%:\AutoTestResults\med_tr_fail.txt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
::Find AM.dds not in DXT5 format https://jira.wargaming.net/browse/WOTA-56770 https://confluence.wargaming.net/pages/viewpage.action?pageId=135355266
for /R %d%:\%version%\res\wot\vehicles %%i in (*_AM.dds) do grep "DXT[1,3]" %%i >> %d%:\AutoTestResults\AM_DXT.log

::Delete garbage
sed -r -e "/tracks|Bottom|crash_inside|Lorraine39_L_AM/d" D:\Projects_autotests\AM_DXT.log >> %d%:\AutoTestResults\AM_DXT_clear.log
del %d%:\AutoTestResults\AM_DXT.log
::Find ANM.dds not in DXT5 format https://jira.wargaming.net/browse/WOTA-56770 https://confluence.wargaming.net/pages/viewpage.action?pageId=135355266
for /R %d%:\%version%\res\wot\vehicles %%i in (*_ANM.dds) do grep "DXT[1,3]" %%i >> %d%:\AutoTestResults\ANM_DXT.log
::Find GMM.dds not in DXT1 format https://jira.wargaming.net/browse/WOTA-56770 https://confluence.wargaming.net/pages/viewpage.action?pageId=135355266
for /R %d%:\%version%\res\wot\vehicles %%i in (*_GMM.dds) do grep "DXT[3,5]" %%i >> %d%:\AutoTestResults\GMM_DXT.log
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
::Search for old (before PBS shader)
::Needs a lot of time, maybe add some "for" special search
::grep -r "lightonly.fx" %d%:\%version%\res\wot\vehicles\ >> %d%:\AutoTestResults\lighonlyfail.txt
::do some sed editing to delete "collision" lines
::sed -r -e "/collision/d" %d%:\AutoTestResults\lighonlyfail.txt >> %d%:\AutoTestResults\lighonlyfail_no_collis.txt

::Search of non-closed tags in scripts
::Invalid regexp
::grep -r "<([A-Z][A-Z0-9]*)[^>]*>\s*</\1>" %d%:\%version%\res\wot\scripts\item_defs\vehicles > %d%:\AutoTestResults\not_closed_tags_scripts.txt

::Search of non-closed tags in content
::Invalid regexp
::grep -r "<([A-Z][A-Z0-9]*)[^>]*>\s*</\1>" %d%:\%version%\res\wot\vehicles > %d%:\AutoTestResults\not_closed_tags_cont.txt

:: WOTA-32711 Search of *.model files with duplicated 
::Very long
::for /R "%d%:\%version%\res\wot\vehicles" %%i in (*.model) do (
::echo %%i >> %d%:\AutoTestResults\model_files_check.txt
::sort "%%i" | uniq -d >> %d%:\AutoTestResults\model_files_check.txt
::grep -v "%d%:\" %d%:\AutoTestResults\model_files_check.txt >> no_ways.txt)

:: WOTA-32711 Search of *.visual files with duplicated 
::Very long
::for /R "%d%:\%version%\res\wot\vehicles" %%i in (*.visual) do (
::echo %%i >> %d%:\AutoTestResults\visual_files_check.txt
::sort "%%i" | uniq -d >> %d%:\AutoTestResults\visual_files_check.txt
::grep -v "%d%:\" %d%:\AutoTestResults\visual_files_check.txt >> no_ways.txt)

::Project of making .pkg files
::cd %d%:\%version%\bigworld\tools\misc\res_packer\
::%d%:\%version%\bigworld\tools\misc\res_packer\bin_convert.py --res "%d%:\%version%\bigworld\res;%d%:\%version%\res\wot" "%d%:\Trunk\res\wot\vehicles\german\G30_Pz_KV-1_756" "%d%:\%version%\game_release_pkg\res\vehicles\german\G30_Pz_KV-1_756"

::??????? ? ????? ? QAT ? ????????? exe ? ???????????:-Test=TestAllTanksInBattle -CreateRandomUser -Server=wotqa27(autotest) -Exe=WorldOfTanks.exe -AutoStart -Setting=UsedVehicleCD:(????????? ??????? ??????????? ??????????? ??????) -Setting=RestartCount:123 -Setting=CheatResearch:False -Setting=VehicleFull:True -SaveToFolder=%savefolder% 

PAUSE
