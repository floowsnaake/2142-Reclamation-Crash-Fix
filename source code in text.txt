;Floowsnaake
;https://battlefield2142.co/
;https://github.com/floowsnaake/2142-Reclamation-Crash-Fix


if not A_IsAdmin
Run *RunAs "%A_ScriptFullPath%"

#SingleInstance,Force

SetWorkingDir, %A_WorkingDir%


IfNotExist,BF2142.exe
{
MsgBox, 64, , This program needs to be run inside BF2142 folder!`n`nmove this exe into BF2142 folder then run it again
}

MsgBox, This Program will check BF2141 for any problems like wrong file versions and patch issues, Green text means everything is okay if its red text that means something is wrong

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

Gui, Add, text, w230 vBFhash ym,1 ; The ym option starts a new column of controls.
Gui, Add, text, w230 vBFhash2,2
Gui, Add, text, w230 vrex91hash,3
Gui, Add, text, w230 vrex92hash,4
Gui, Add, text, w230 vpatch,5
Gui, Add, Edit,ReadOnly Wrap vpath,%path_out%

Gui, Add, text, Uppercase w230 vcdkey,%cd_out_fix%
Gui, Add, text,,%A_OSVersion% %A_Is64bitOS%


gui, font, s8, Verdana 
Gui, Add, Button, GB1 xm, Delete Profile  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Add, Button, GB3,Reclamation website
Gui, Add, Button, GB4,Open Map Folder

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


Gui, Add, Text,cTeal, Floowsnaake // https://battlefield2142.co/ // https://github.com/floowsnaake/
Gui, Show,, BF2142 Reclamation Game Fix 1.1

IF (Errorone = "Yes")
{
    Sleep,2000
    
MsgBox, 4116, , %info%
IfMsgBox Yes
    run,https://battlefield2142.co/downloads/
else
return


}

return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ExitApp
return

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
info = %File% Wrong!, File Error this File: %File% Does not match Hash/file id number with this file: %Hash%`nCorrect hash is %A%`n`nDo you want to open the webbrowser to download the fix?:`n`nhttps://github.com/floowsnaake/2142-Reclamation-Crash-Fix`n
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
        MsgBox, 48, Error, Could not find file: %filename%`nMake sure that the file is in the same folder as this program!`n
    f.Seek(0)
    while (dataread := f.RawRead(data, 262144))
        crc := DllCall("ntdll.dll\RtlComputeCrc32", "uint", crc, "ptr", &data, "uint", dataread, "uint")
    f.Close()
    return Format("{:#X}", crc)
}

