Set Fs = CreateObject("Scripting.FileSystemObject")
Set Shell = CreateObject("WScript.Shell")

Sub Die(Message)
  MsgBox Message, vbExclamation, "Vim"
  WScript.Quit 1
End Sub

Function GetVimFolder()
  On Error Resume Next
  Set GetVimFolder = Fs.GetFolder(Fs.BuildPath(Shell.Environment("Process")("ProgramFiles"), "vim"))
  If GetVimFolder Is Nothing Then Die "Can’t start Vim: " & Err.Description
End FUnction

Function GetVimVersionFolder(VimFolder)
  Set Pattern = CreateObject("VBScript.RegExp")
  Pattern.Pattern = "^vim(\d+)$"
  Version = -1
  For Each Folder In VimFolder.SubFolders
    Set Matches = Pattern.Execute(Folder.Name)
    If Matches.Count > 0 Then
      NewVersion = CInt(Matches(0).SubMatches(0))
      If NewVersion > Version Then
        Version = NewVersion
        Set GetVimVersionFolder = Folder
      End If
    End If
  Next
  If GetVimVersionFolder Is Nothing Then MsgBox "Can’t start Vim: Can’t find a Vim installation"
End Function

Function GetVimExecutables(VersionFolder, GVim)
  GetVimExecutables = Fs.BuildPath(VersionFolder.Path, "vim.exe")

  Set Pattern = CreateObject("VBScript.RegExp")
  Pattern.Pattern = "^(.*)vim"
  GVim = Pattern.Replace(GetVimExecutables, "$1gvim")
End Function

Function IsServerRunning(Vim)
  Set Command = Shell.Exec(Vim & " --serverlist")
  Do While Command.Status = 0
    WScript.Sleep 50
  Loop
  Do Until Command.StdOut.AtEndOfStream
    IsServerRunning = Command.StdOut.ReadLine = "VIM"
    If IsServerRunning Then Exit Do
  Loop
End Function

Function BuildCommand(Vim, GVim)
  BuildCommand = Gvim & " --servername vim "
  If IsServerRunning(Vim) Then
    BuildCommand = BuildCommand & "--remote "
  ElseIf WScript.Arguments.Count = 0 Then
    WScript.Quit
  End If
  For Each Argument In WScript.Arguments
    BuildCommand = BuildCommand & """" & Argument & """ "
  Next
End Function

GVim = ""
Shell.Exec BuildCommand(GetVimExecutables(GetVimVersionFolder(GetVimFolder()), GVim), GVim)
