Attribute VB_Name = "modWinAPI"
Option Explicit
'UNC�Ή��̂��߁AWin32API�g�p
Public Declare PtrSafe Function SetCurrentDirectoryW Lib "kernel32" (ByVal lpPathName As LongPtr) As LongPtr
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
'�֐���`
Public Declare PtrSafe Sub GetLocalTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)
'���T�C�Y�����̂���Win32API�g�p
'const
Public Const GWL_STYLE As Long = (-16)                     '�E�B���h�E�X�^�C���̃n���h���ԍ�
Public Const WS_MAXIMIZEBOX As Long = &H10000  '�E�B���h�E�X�^�C���ōő剻�{�^��������
Public Const WS_MINIMIZEBOX As Long = &H20000  '�E�B���h�E�X�^�C���ōŏ����{�^����t����
Public Const WS_THICKFRAME As Long = &H40000   '�E�B���h�E�X�^�C���ŃT�C�Y�ύX������
Public Const WS_SYSMENU As Long = &H80000      '�E�B���h�E�X�^�C���ŃR���g���[�����j���[�{�b�N�X�����E�B���h�E���쐬����
'-----Windows API�錾-----
Public Declare PtrSafe Function GetActiveWindow Lib "user32" () As LongPtr
#If Win64 Then
Public Declare PtrSafe Function GetWindowLongPtr Lib "user32" Alias "GetWindowLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long) As LongPtr
Public Declare PtrSafe Function SetWindowLongPtr Lib "user32" Alias "SetWindowLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
Public Declare PtrSafe Function SetClassLongPtr Lib "user32" Alias "SetClassLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
#Else
Public Declare PtrSafe Function GetWindowLongPtr Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long) As LongPtr
Public Declare PtrSafe Function SetWindowLongPtr Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
Public Declare PtrSafe Function SetClassLongPtr Lib "user32" Alias "SetClassLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
#End If
'�t�H�[���ɍő剻�E���T�C�Y�@�\��ǉ�����B
Public Sub FormResize()
        Dim hwnd As LongPtr
        Dim WndStyle As LongPtr
    '�E�B���h�E�n���h���̎擾
    hwnd = GetActiveWindow()
    '�E�B���h�E�̃X�^�C�����擾
    WndStyle = GetWindowLongPtr(hwnd, GWL_STYLE)
    '�ő�E�ŏ��E�T�C�Y�ύX��ǉ�����
    WndStyle = WndStyle Or WS_THICKFRAME Or WS_MAXIMIZEBOX Or WS_MINIMIZEBOX Or WS_SYSMENU
    Call SetWindowLongPtr(hwnd, GWL_STYLE, WndStyle)
End Sub