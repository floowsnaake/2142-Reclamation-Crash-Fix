;Floowsnaake
;https://battlefield2142.co/
;https://github.com/floowsnaake/2142-Reclamation-Crash-Fix


if not A_IsAdmin
Run *RunAs "%A_ScriptFullPath%"


#SingleInstance,Force

SetWorkingDir, %A_WorkingDir%

CopyDir = %A_WorkingDir%/Patch_Files

ext  := [.exe, .dll]


IfNotExist,BF2142.exe
{
MsgBox, 8224, This program needs to be run inside of the BF2142 folder!`n`nmove this Patcher.exe into BF2142 folder then run it again!
ExitApp
}




MsgBox, 8224, BF2142 Patcher, This Program will check BF2141 for any problems like wrong file versions and patch issues`, Green means no errors Red means that there are some problems with the game file/files.`n`nPress the Patch button to patch/fix the bad game files

Global info
Global Errorone


RegRead, version_out, HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Electronic Arts\EA GAMES\Battlefield 2142,Version
RegRead, path_out, HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Electronic Arts\EA GAMES\Battlefield 2142,InstallDir
RegRead, cd_out, HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Electronic Arts\EA GAMES\Battlefield 2142\ergc


StringTrimLeft, cd_out_fix, cd_out, 5

gui, font, s10, Verdana 
Gui, Add, Text,, BF2142.exe
Gui, Add, Text,, BF2142_ori.exe
Gui, Add, Text,, RendDX9.dll
Gui, Add, Text,, RendDX9_ori.dll
Gui, Add, Text,, BF2142 Patch
Gui, Add, Text,, Install Path
Gui, Add, Text,,CD Key
Gui, Add, Text,,Windows Version

Gui, Add, text, w230 vBFhash ym, ; The ym option starts a new column of controls.
Gui, Add, text, w230 vBFhash2,
Gui, Add, text, w230 vrex91hash,
Gui, Add, text, w230 vrex92hash,
Gui, Add, text, w230 vpatch,
Gui, Add, Edit,ReadOnly Wrap vpath,%path_out%

Gui, Add, text, Uppercase w230 vcdkey,%cd_out_fix%
Gui, Add, text,,%A_OSVersion% %A_Is64bitOS%


gui, font, s8, Verdana 
Gui, Add, Button, GB0 xm, Patch files
Gui, Add, Button, GB1, Delete Profile  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Add, Button, GB3,Reclamation website
Gui, Add, Button, GB4,Open Map Folder


Gui, Add, link,cGreen, Floowsnaake // <a href="https://battlefield2142.co/">BF2142 Reclamation</a> // <a href="https://github.com/floowsnaake/">Github</a> 

Check_hash("BF2142.exe","0XF35DA67","BFhash") Check_hash("BF2142_ori.exe","0XF35DA67","BFhash2") Check_hash("RendDX9.dll","0XF848DA88","rex91hash") Check_hash("RendDX9_ori.dll","0X6A6967C3","rex92hash")

IF (version_out = 1.51)
{
GuiControl, +cGreen, patch
GuiControl,,patch,%version_out% / 1.51 OK
}

IF NOT (version_out = 1.51)
{
GuiControl, +cRed, patch
GuiControl,,patch,%version_out% / 1.51 ERROR

 

MsgBox, 4112, Patch Error, Game is not updated to 1.51!`n`n Do you want to open the webbrowser to download the fix?
IfMsgBox Yes
    run,https://battlefield2142.co/downloads/
else
return



}


GuiControl,,path,%path_out%


Gui, Show,, BF2142 Reclamation Patcher 1.5
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ExitApp
return



B0:

Gui, progg:font, s10, Verdana 

Gui, progg:Add, Text, xm w360 vProgressFile, Patching Files...`nPlease Wait
Gui, progg:Add, Progress, xm w300 h20 vProgressBar -Smooth

Gui, progg:Show,,Patching Game...

Loop, %CopyDir%\%A_LoopFileName%\*%ext%
   FileCount++ ; count the number of files in the source directory

Loop,%CopyDir%\%A_LoopFileName%\*%ext%
{


   GuiControl,progg:, ProgressFile, Patching...`n%A_LoopFileName%...

   FileCopy, %CopyDir%\%A_LoopFileName%, %A_WorkingDir%/%A_LoopFileName%, 1

   Percent := Floor( A_Index / FileCount * 100 )
   GuiControl,progg:, ProgressBar, %Percent%
   GuiControl,progg:, ProgressText, %Percent%`% Complete
}

if (Percent = 100)
{
GuiControl,progg:, ProgressText,Patched!
GuiControl,progg:, ProgressFile, Complete`nPatch Complete 100
sleep,1000
Check_hash("BF2142.exe","0XF35DA67","BFhash") Check_hash("BF2142_ori.exe","0XF35DA67","BFhash2") Check_hash("RendDX9.dll","0XF848DA88","rex91hash") Check_hash("RendDX9_ori.dll","0X6A6967C3","rex92hash")
sleep,1000
WinHide Patching Game...


MsgBox, 64, Patching, Game Patch complete now run Battlefield 2142 and IF you still have problems then run the installers in the setup folder or go to the BF2142 forum for more help.



}
Return


;\mods\bf2142\Levels
B1:
FileRemoveDir,%A_MyDocuments%\Battlefield 2142,1
MsgBox Deleted %A_MyDocuments%\Battlefield 2142.
return


B3:
Run,https://battlefield2142.co/
return

B4:
Run, %path_out%\mods\bf2142\Levels
return


Check_hash(File,Hash,Gcontrol)
{
Global
A = % CRC32_File(File)

IF NOT (A = Hash)
{
GuiControl, +cRed, %Gcontrol%
GuiControl,,%Gcontrol%,%Hash% / %A% Error

Errorone = Yes
}

IF (A = Hash)
{
GuiControl, +cGreen, %Gcontrol%

GuiControl,,%Gcontrol%,%Hash% / %A% OK

}
}


CRC32_File(filename)
{
    if !(f := FileOpen(filename, "r", "UTF-8"))
        ; MsgBox, 48, Error, Could not find file: %filename%`nMake sure that the file is in the same folder as this program!`n
    f.Seek(0)
    while (dataread := f.RawRead(data, 262144))
        crc := DllCall("ntdll.dll\RtlComputeCrc32", "uint", crc, "ptr", &data, "uint", dataread, "uint")
    f.Close()
    return Format("{:#X}", crc)
}

