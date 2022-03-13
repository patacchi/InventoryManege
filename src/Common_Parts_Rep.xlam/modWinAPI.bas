Attribute VB_Name = "modWinAPI"
Option Explicit
'Windows API �֐���`
#If VBA7 And Win64 Then
    Public Declare PtrSafe Function GetWindowLongPtr Lib "user32" Alias "GetWindowLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long) As LongPtr
    Public Declare PtrSafe Function SetWindowLongPtr Lib "user32" Alias "SetWindowLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
    Public Declare PtrSafe Function SetClassLongPtr Lib "user32" Alias "SetClassLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
    Public Declare PtrSafe Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As LongPtr, ByVal lParam As LongPtr) As Long
    Public Declare PtrSafe Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As LongPtr
    Public Declare PtrSafe Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWndparent As LongPtr, ByVal hWndchild As LongPtr, ByVal lpClassName As String, ByVal lpWindowName As String) As LongPtr
#Else
    Public Declare PtrSafe Function GetWindowLongPtr Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long) As LongPtr
    Public Declare PtrSafe Function SetWindowLongPtr Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
    Public Declare PtrSafe Function SetClassLongPtr Lib "user32" Alias "SetClassLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
    Public Declare PtrSafe Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Public Declare PtrSafe Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
    Private Declare PtrSafe Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWndparent As Long, ByVal hWndchild As Long, ByVal lpClassName As String, ByVal lpWindowName As String) As Long
#End If
Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Public Declare PtrSafe Function IsWindowVisible Lib "user32" (ByVal hwnd As LongPtr) As Long
Public Declare PtrSafe Function ShowWindow Lib "user32" (ByVal hwnd As LongPtr, ByVal nCmdShow As Long) As Long
Public Declare PtrSafe Function GetWindow Lib "user32" (ByVal hwndOwner As LongPtr, ByVal wCmdGW_ As Long) As LongPtr
Public Declare PtrSafe Function SetForegroundWindow Lib "user32" (ByVal hwnd As LongPtr) As Long
Public Declare PtrSafe Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, ByRef lpvParam As Any, ByVal fuWinIni As Long) As Long
Public Declare PtrSafe Function BringWindowToTop Lib "user32" (ByVal hwnd As LongPtr) As Long
Public Declare PtrSafe Function GetForegroundWindow Lib "user32" () As LongPtr
Public Declare PtrSafe Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As LongPtr, lpdwProcessId As Long) As Long
Public Declare PtrSafe Function AttachThreadInput Lib "user32" (ByVal idAttach As Long, ByVal idAttachTo As Long, ByVal fAttach As Long) As Long
Public Declare PtrSafe Function MoveWindow Lib "user32" (ByVal hwnd As LongPtr, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long
Private Declare PtrSafe Function GetDC Lib "user32" (ByVal hwnd As LongPtr) As LongPtr
Private Declare PtrSafe Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As LongPtr) As LongPtr
Private Declare PtrSafe Function SelectObject Lib "gdi32" (ByVal hdc As LongPtr, ByVal hObject As LongPtr) As LongPtr
Private Declare PtrSafe Function DeleteObject Lib "gdi32" (ByVal hObject As LongPtr) As Long
Private Declare PtrSafe Function ReleaseDC Lib "user32" (ByVal hwnd As LongPtr, ByVal hdc As LongPtr) As Long
Private Declare PtrSafe Function CreateFont Lib "gdi32" Alias "CreateFontA" (ByVal nHeight As Long, _
    ByVal nWidth As Long, _
    ByVal nEscapement As Long, _
    ByVal nOrientation As Long, _
    ByVal fnWeight As Long, _
    ByVal IfdwItalic As Long, _
    ByVal fdwUnderline As Long, _
    ByVal fdwStrikeOut As Long, _
    ByVal fdwCharSet As Long, _
    ByVal fdwOutputPrecision As Long, _
    ByVal fdwClipPrecision As Long, _
    ByVal fdwQuality As Long, _
    ByVal fdwPitchAndFamily As Long, _
    ByVal lpszFace As String) As LongPtr
Private Declare PtrSafe Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hdc As LongPtr, _
    ByVal lpStr As String, _
    ByVal nCount As Long, _
    lpRect As RECT, _
    ByVal wFormat As Long) As Long
'-----------------------------------------------------------------------------------------------------------------------
'UNC�Ή��̂��߁AWin32API�g�p
Public Declare PtrSafe Function SetCurrentDirectoryW Lib "kernel32" (ByVal lpPathName As LongPtr) As LongPtr
'-----------------------------------------------------------------------------------------------------------------------
'�萔�E�\���̒�`
Public Declare PtrSafe Sub GetLocalTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)
Public Declare PtrSafe Function GetActiveWindow Lib "user32" () As LongPtr
'���t���~���b�P�ʂŎ擾����̂�Win32API���g�p
'SYSTEMTIME�\���̒�`
Type SYSTEMTIME
        wYear As Integer
        wMonth As Integer
        wDayOfWeek As Integer
        wDay As Integer
        wHour As Integer
        wMinute As Integer
        wSecond As Integer
        wMilliseconds As Integer
End Type
'RECT�\���̒�`
Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type
'const GetWindowLongPtr() �y�� SetWindowLongPtr()�Ŏg�p����萔
Public Const GWL_STYLE As Long = (-16)              '�E�B���h�E�X�^�C���̃n���h���ԍ�
Public Const WS_MAXIMIZEBOX As Long = &H10000       '�E�B���h�E�X�^�C���ōő剻�{�^��������
Public Const WS_MINIMIZEBOX As Long = &H20000       '�E�B���h�E�X�^�C���ōŏ����{�^����t����
Public Const WS_THICKFRAME As Long = &H40000        '�E�B���h�E�X�^�C���ŃT�C�Y�ύX������
Public Const WS_SYSMENU As Long = &H80000           '�E�B���h�E�X�^�C���ŃR���g���[�����j���[�{�b�N�X�����E�B���h�E���쐬����
' ShowWindow() Commands
Public Const SW_HIDE = 0
Public Const SW_SHOWNORMAL = 1
Public Const SW_NORMAL = 1
Public Const SW_SHOWMINIMIZED = 2
Public Const SW_SHOWMAXIMIZED = 3
Public Const SW_MAXIMIZE = 3
Public Const SW_SHOWNOACTIVATE = 4
Public Const SW_SHOW = 5
Public Const SW_MINIMIZE = 6
Public Const SW_SHOWMINNOACTIVE = 7
Public Const SW_SHOWNA = 8
Public Const SW_RESTORE = 9
Public Const SW_SHOWDEFAULT = 10
Public Const SW_MAX = 10
'GetWindows() GW_Cmd
Public Const GW_HWNDFIRST As Long = 0
Public Const GW_HWNDLAST As Long = 1
Public Const GW_HWNDNEXT As Long = 2
Public Const GW_HWNDPREV As Long = 3
Public Const GW_OWNER As Long = 4
Public Const GW_CHILD As Long = 5
Public Const GW_ENABLEPOPUP As Long = 6
'SystemParametersInfo
Public Const SPI_GETFOREGROUNDLOCKTIMEOUT As Long = &H2000&
Public Const SPI_SETFOREGROUNDLOCKTIMEOUT As Long = &H2001&
Public Const SPIF_SENDCHANGE As Long = &H2
'DownloadPath�擾�p���W�X�g���L�[
Public Const REG_DOWNLOADPATH As String = "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\{374DE290-123F-4565-9164-39C4925E467B}"
'CreateFont�p�萔
Private Const FW_NORMAL = 400
Private Const FW_BOLD = 700
Private Const DEFAULT_CHARSET = 1
Private Const OUT_DEFAULT_PRECIS = 0
Private Const CLIP_DEFAULT_PRECIS = 0
Private Const DEFAULT_QUALITY = 0
Private Const DEFAULT_PITCH = 0
Private Const FF_SCRIPT = 64
Private Const DT_CALCRECT = &H400
'-----------------------------------------------------------------------------------------------------------------------
'�v���V�[�W����`
'�t�H�[���ɍő剻�E���T�C�Y�@�\��ǉ�����B
Public Sub FormResize(Optional hwnd As LongPtr = 0)
    Dim WndStyle As LongPtr
    If hwnd = 0 Then
        '�n���h�����w�肳��Ȃ������ꍇ�́A�A�N�e�B�u�E�B���h�E�̃n���h�����擾����
        '�E�B���h�E�n���h���̎擾
        hwnd = GetActiveWindow()
    End If
    '�E�B���h�E�̃X�^�C�����擾
    WndStyle = GetWindowLongPtr(hwnd, GWL_STYLE)
    '�ő�E�ŏ��E�T�C�Y�ύX��ǉ�����
    WndStyle = WndStyle Or WS_THICKFRAME Or WS_MAXIMIZEBOX Or WS_MINIMIZEBOX Or WS_SYSMENU
    Call SetWindowLongPtr(hwnd, GWL_STYLE, WndStyle)
End Sub
'''�^���炽������A�t�H���g�A�T�C�Y�����ʂ̎��`�撷���擾����֐�
'''Return Long      ���`��|�C���g��?
'''args
'''strargTargetText         �^�[�Q�b�g�ƂȂ�e�L�X�g
'''strargFONT_NAME          �t�H���g��
'''longargFont_Height       �t�H���g�T�C�Y?�c�̒����炵�����ǁE�E�E
Public Function MesureTextWidth( _
    strargTargetText As String, _
    strargFONT_NAME As String, _
    longargFont_Height As Long) As Long
    On Error GoTo ErrorCatch
    '��ʑS�̂̕`��̈�̃n���h�����擾
    Dim hwholeScreenDC As LongPtr
    hwholeScreenDC = GetDC(0&)
    '���z��ʕ`��̈�̃n���h�����擾
    Dim hvirtualDC As LongPtr
    hvirtualDC = CreateCompatibleDC(hwholeScreenDC)
    '�t�H���g�̃n���h�����擾
    Dim hFont As LongPtr
    hFont = CreateFont(longargFont_Height, 0, 0, 0, FW_NORMAL, _
    0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, _
    CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, _
    DEFAULT_PITCH Or FF_SCRIPT, strargFONT_NAME)
    '���z�`��̈�Ƀt�H���g��ݒ�
    Call SelectObject(hvirtualDC, hFont)
    '�`��̈�̎��͂��擾
    Dim DrawAreaRectangle As RECT
    '�ݒ肵���t�H���g��K�p���A�e�L�X�g�����o��
    Call DrawText(hvirtualDC, strargTargetText, -1, DrawAreaRectangle, DT_CALCRECT)
    '�g�p�����I�u�W�F�N�g���J������
    Call DeleteObject(hFont)
    Call DeleteObject(hvirtualDC)
    Call ReleaseDC(0&, hwholeScreenDC)
    '���ʂ�Ԃ�
    MesureTextWidth = DrawAreaRectangle.Right - DrawAreaRectangle.Left
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "MesureTextWidth code : " & Err.Number & " Descriptoin: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function