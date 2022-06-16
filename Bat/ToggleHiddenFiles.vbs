' Script to toggle Windows Explorer display of hidden files,
' super-hidden files, and file name extensions

Option Explicit
Dim dblHiddenData, strHiddenKey, strSuperHiddenKey, strFileExtKey
Dim strKey, WshShell
On Error Resume Next

strKey = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
strHiddenKey = strKey & "\Hidden"
strSuperHiddenKey = strKey & "\ShowSuperHidden"
strFileExtKey = strKey & "\HideFileExt"

Set WshShell = WScript.CreateObject("WScript.Shell")
dblHiddenData = WshShell.RegRead(strHiddenKey)

If dblHiddenData = 2 Then
	WshShell.RegWrite strHiddenKey, 1, "REG_DWORD"
	' WshShell.RegWrite strSuperHiddenKey, 1, "REG_DWORD"
	' WshShell.RegWrite strFileExtKey, 0, "REG_DWORD"
	' WScript.Echo "Windows Explorer will show hidden files and file " & _
	' 	"name extensions. You might need to change to another folder " & _
	' 	"or press F5 to refresh the view for the change to take effect."

Else
	WshShell.RegWrite strHiddenKey, 2, "REG_DWORD"
	' WshShell.RegWrite strSuperHiddenKey, 0, "REG_DWORD"
	' WshShell.RegWrite strFileExtKey, 1, "REG_DWORD"
	' WScript.Echo "Windows Explorer will not show hidden files or file " & _
	' 	"name extensions. (These are the default settings.) You might " & _
	' 	"need to change to another folder or press F5 to refresh the " & _
	' 	"view for the change to take effect."

End If