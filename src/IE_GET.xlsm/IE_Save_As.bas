Attribute VB_Name = "IE_Save_As"
'''IE����ɂ����āA�t�@�C���_�E�����[�h���ɖ��O��t���ĕۑ��iSave as)���s�����߂̃��W���[��
'�Q�Ɛݒ�F UIAutomationClient
Option Explicit
'''Windows API�錾
#If VBA7 And Win64 Then
'    Declare PtrSafe Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As LongPtr, ByVal lParam As LongPtr) As LongPtr
    Public Declare PtrSafe Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As LongPtr, ByVal lParam As LongPtr) As Long
    Public Declare PtrSafe Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As LongPtr
    Public Declare PtrSafe Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWndparent As LongPtr, ByVal hWndchild As LongPtr, ByVal lpClassName As String, ByVal lpWindowName As String) As LongPtr
#Else
    Public Declare PtrSafe Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Public Declare PtrSafe Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
    Private Declare PtrSafe Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWndparent As Long, ByVal hWndchild As Long, ByVal lpClassName As String, ByVal lpWindowName As String) As Long
#End If
Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Declare PtrSafe Function IsWindowVisible Lib "user32" (ByVal hwnd As LongPtr) As Long
Declare PtrSafe Function ShowWindow Lib "user32" (ByVal hwnd As LongPtr, ByVal nCmdShow As Long) As Long
'�萔�錾
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
'Sleep Default Time
Public Const SLEEP_DEFAULT_MILLISEC As Long = 100                           '���[�v�҂��̕W���~���b
Public Const WM_SYSCHAR As Long = &H106&                                    'PostMessage�p�ASystem Charactor ALT�L�[��������Ԃ̃L�[���b�Z�[�W
Public Const NOTIFICATION_CLASS_NAME As String = "Frame Notification Bar"   'FindWindow�p�A�ʒm�o�[�̃N���X��
Public Const NOTIFICATION_SAVE_BUTTON_NAME As String = "�ۑ�"               '�ʒm�o�[��[�ۑ�]�{�^����Name
Public Const NOTIFICATION_TEXT As String = "�ʒm�o�[�̃e�L�X�g"             '�ʒm�o�[�̃e�L�X�g��Name
Public Const NOTIFICATION_CLOSE_BUTTON_NAME As String = "����"            '�ʒm�o�[��[����]�{�^����Name
Public Const ROLE_SYSTEM_BUTTONDROPDOWN = &H38&                             '�h���b�v�_�E���{�^��
Public Const CONTEXT_MENU_CLASS_NAME As String = "#32768"                   '�R���e�L�X�g���j���[�̃N���X���A���O��t���ĕۑ��̃h���b�v�_�E��������̂�����
Public Const SAVEASDIALOG_NAME As String = "���O��t���ĕۑ�"               '���O��t���ĕۑ��_�C�A���O�{�b�N�X��Name
Public Const SAVEASDIALOG_FILE_NAME As String = "�t�@�C����:"               '�t�@�C�����R���{�{�b�N�X��Name
Public Const SAVEASDIALOG_SAVEAS_BUTTON_NAME As String = "�ۑ�(S)"          '�ۑ��{�^����Name
Public Const SAVEASTIMEOUT As Long = 30                                     'SaveAs�E�B���h�E����������Ƃ��̃^�C���A�E�g����

'''Module
'---------------------------------------------------------------------------------------------------------------
'''IE�̃n���h���ƕۑ��t�@�C�����������Ƃ��āA���O��t���ĕۑ��̃{�^�����������
'Return �ŏI�I�ɕۑ����ꂽ�t�@�C����(�p�X�����j��String�ŕԂ�
'���I�w�肳�ꂽ�t�@�C�������݂���ꍇ�͋����I�ɍ폜����܂��I�I�I
Public Function DownloadNotificationBarSaveAs(ByRef hIE As LongPtr, ByVal strargSaveFilePath As String) As String
    '�n���h���ƕۑ��t�@�C�����͕K�{�Ȃ̂ŁA�ǂ��炩���w�肳��Ă��Ȃ������甲����
    If hIE = 0 Or strargSaveFilePath = "" Then
        Debug.Print Now() & " DownloadNotificationBarSaveAs: handle or Save Filneme is empty"
        DownloadNotificationBarSaveAs = ""
        Exit Function
    End If
    On Error GoTo ErrorCatch
    '�w�肳�ꂽ�t�@�C�������݂��Ă�����폜����
    With CreateObject("Scripting.FileSystemObject")
      If .FileExists(strargSaveFilePath) Then .DeleteFile strargSaveFilePath, True
    End With
    Dim uiAuto As CUIAutomation
    Set uiAuto = New CUIAutomation
    '�ʒm�o�[��[�ʖ��ŕۑ�]������
    If Not PressSaveAsNotificationBar(uiAuto, hIE) Then
        '���s�����悤�ł���
        '�G���[�\���Ƃ��͊e�v���V�[�W���ɋL�q����
        DownloadNotificationBarSaveAs = ""
        Exit Function
    End If
    '[���O��t���ĕۑ�]�_�C�A���O����
    If Not SaveAsFilenameDialog(uiAuto, strargSaveFilePath) Then
        DownloadNotificationBarSaveAs = ""
        Exit Function
    End If
    'IE��ʏ�\���ɖ߂�
    Call ShowWindow(hIE, SW_RESTORE)
    '�_�E�����[�h������ʒm�o�[�����
    '�߂�l�Ƃ��ăt�@�C���������Ă�͂��Ȃ̂ŁA�������f�B���N�g������t�����A�t���p�X��Ԃ�
    Dim strResultFileName As String
    strResultFileName = ClosingNotificationBar(uiAuto, hIE)
    With CreateObject("Scripting.FilesystemObject")
        '�f�B���N�g������t�����A�t���p�X�ɂ���
        DownloadNotificationBarSaveAs = .BuildPath(.GetParentFolderName(strargSaveFilePath), strResultFileName)
        '�f�o�b�O�o��
        Debug.Print "DownloadNotificationBarSaveAs complete. file name: " & .BuildPath(.GetParentFolderName(strargSaveFilePath), strResultFileName)
    End With
    Set uiAuto = Nothing
    Exit Function
ErrorCatch:
    Debug.Print Now() & " DownloadNotificationBarSaveAs code: " & Err.Number & " Description: " & Err.Description
    DownloadNotificationBarSaveAs = ""
    Exit Function
End Function
'---------------------------------------------------------------------------------------------------------------
'''�ʒm�o�[��[�ʖ��ŕۑ�]������
Private Function PressSaveAsNotificationBar(ByRef argUIAuto As CUIAutomation, ByVal hIEWnd As LongPtr) As Boolean
    'uiAuto��IE�n���h�������Ƃ��K�{�Ȃ̂ň����`�F�b�N�����������甲����
    If argUIAuto Is Nothing Or hIEWnd = 0 Then
        Debug.Print Now() & " PressSaverAsNothificationBar: uiAuto or IEHandle empry"
        PressSaveAsNotificationBar = False
        Exit Function
    End If
    '�ʒm�o�[���擾
    Dim hWndNotification As LongPtr
    Dim dateStart As Date
    '�����J�n���Ԃ��擾
    dateStart = Now()
    Application.StatusBar = "�ʒm�o�[�擾��"
    On Error GoTo ErrorCatch
    Do
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        hWndNotification = FindWindowEx(hIEWnd, 0&, NOTIFICATION_CLASS_NAME, vbNullString)
        '�^�C���A�E�g���Ԃ��߂��Ă����狭���I������
        If Second(Now() - dateStart) >= SAVEASTIMEOUT Then
            MsgBox "�ʒm�o�[��������" & SAVEASTIMEOUT & "�b�̃^�C���A�E�g���Ԃ𒴉߂��܂����B�����𒆒f���܂�"
            PressSaveAsNotificationBar = False
            Exit Function
        End If
    Loop Until hWndNotification
    '�ʒm�o�[������ԂɂȂ�܂őҋ@�i��������Ȃ��Ƒ���Ɏ��s���邱�Ƃ�����E�E�E�炵���j
    Application.StatusBar = "�ʒm�o�[������"
    Do
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        '�^�C���A�E�g���Ԃ��߂��Ă����狭���I������
        If Second(Now() - dateStart) >= SAVEASTIMEOUT Then
            MsgBox "�ʒm�o�[��������" & SAVEASTIMEOUT & "�b�̃^�C���A�E�g���Ԃ𒴉߂��܂����B�����𒆒f���܂�"
            PressSaveAsNotificationBar = False
            Exit Function
        End If
    Loop Until IsWindowVisible(hWndNotification)
    Debug.Print Second(Now() - dateStart) & " �b�Œʒm�o�[�擾����"
    '[�ۑ�]�X�v���b�g�{�^���擾
'    Application.StatusBar = "�ۑ��{�^���擾��"
    Dim elmNotificationBar As IUIAutomationElement
    Set elmNotificationBar = argUIAuto.ElementFromHandle(ByVal hWndNotification)
    Dim elmASaveSplitButton As IUIAutomationElement
    Do
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        Set elmASaveSplitButton = GetUIElement(argUIAuto, _
                                                elmNotificationBar, UIA_NamePropertyId, _
                                                NOTIFICATION_SAVE_BUTTON_NAME, _
                                                UIA_SplitButtonControlTypeId)
    Loop While elmASaveSplitButton Is Nothing
    '[�ۑ�]�{�^���̃h���b�v�_�E���擾
    Dim elmSaveAsDropDownButton As IUIAutomationElement
    Do
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        Set elmSaveAsDropDownButton = GetUIElement(argUIAuto, _
                                                    elmNotificationBar, _
                                                    UIA_LegacyIAccessibleRolePropertyId, _
                                                    ROLE_SYSTEM_BUTTONDROPDOWN, _
                                                    UIA_SplitButtonControlTypeId)
    Loop While elmSaveAsDropDownButton Is Nothing
    '[�ۑ�]�h���b�v�_�E���{�^������
    Dim iptn As IUIAutomationInvokePattern
    Set iptn = elmSaveAsDropDownButton.GetCurrentPattern(UIA_InvokePatternId)
    '���j���[�E�B���h�E�i�R���e�L�X�g���j���[�j�̎擾
    Application.StatusBar = "�R���e�L�X�g���j���[�擾"
    Dim elmSaveMenyu As IUIAutomationElement
    Do
        '�h���b�v�_�E���{�^��.click()
        iptn.Invoke
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        Set elmSaveMenyu = GetUIElement(argUIAuto, _
                                        argUIAuto.GetRootElement, _
                                        UIA_ClassNamePropertyId, _
                                        CONTEXT_MENU_CLASS_NAME, _
                                        UIA_MenuControlTypeId)
    Loop While elmSaveMenyu Is Nothing
    '[���O��t���ĕۑ�(A)]�{�^������
    '��������PostMessage�ōs��
    Dim hWndSaveMenu As LongPtr
    hWndSaveMenu = FindWindow(CONTEXT_MENU_CLASS_NAME, vbNullString)
    PostMessage hWndSaveMenu, WM_SYSCHAR, vbKeyA, 0&
    PressSaveAsNotificationBar = True
    Exit Function
ErrorCatch:
    Debug.Print "PressSaveAsNothificationBar code: " & Err.Number & " Description: = " & Err.Description
    PressSaveAsNotificationBar = False
    Exit Function
End Function
'---------------------------------------------------------------------------------------------------------------
'''[���O��t���ĕۑ�]�_�C�A���O�{�b�N�X�̑���
Private Function SaveAsFilenameDialog(ByRef argUIAuto As CUIAutomation, ByVal strSaveFilePath As String) As Boolean
    If argUIAuto Is Nothing Or strSaveFilePath = "" Then
        '�������󂾂����甲����
        Debug.Print "SaveAsFilenameDialog: UIAuto or SaveFilePath is empty"
        SaveAsFilenameDialog = False
        Exit Function
    End If
    '[���O��t���ĕۑ�]�_�C�A���O�{�b�N�X�̎擾
    Application.StatusBar = "���O��t���ĕۑ��_�C�A���O�{�b�N�X���쒆"
    On Error GoTo ErrorCatch
    Dim elmSaveAsDialog As IUIAutomationElement
    Do
        Set elmSaveAsDialog = GetUIElement(argUIAuto, _
                                            argUIAuto.GetRootElement, _
                                            UIA_NamePropertyId, _
                                            SAVEASDIALOG_NAME, _
                                            UIA_WindowControlTypeId)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
    Loop While elmSaveAsDialog Is Nothing
    '�t�@�C�����G�f�B�b�g�{�b�N�X�i�R���{�{�b�N�X�j�̎擾
    Dim elmFileNameComboBox As IUIAutomationElement
    Do
        Set elmFileNameComboBox = GetUIElement(argUIAuto, _
                                                elmSaveAsDialog, _
                                                UIA_NamePropertyId, _
                                                SAVEASDIALOG_FILE_NAME, _
                                                UIA_EditControlTypeId)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
    Loop While elmFileNameComboBox Is Nothing
    '�t�@�C���p�X�̓���
    Dim vptn As IUIAutomationValuePattern
    Set vptn = elmFileNameComboBox.GetCurrentPattern(UIA_ValuePatternId)
    vptn.SetValue strSaveFilePath
    '���O��t���ĕۑ��_�C�A���O�̍ŏ��������݂�
    Dim hWndSaveAsDialog As LongPtr
    hWndSaveAsDialog = FindWindow("#32770", SAVEASDIALOG_NAME)
    If hWndSaveAsDialog <> 0 Then
        '�ŏ������Ă݂�
        Call ShowWindow(hWndSaveAsDialog, SW_MINIMIZE)
    End If
    Application.StatusBar = "�ۑ�������"
    '[�ۑ�(S)]�{�^���擾
    Dim elmSaveButton As IUIAutomationElement
    Do
        Set elmSaveButton = GetUIElement(argUIAuto, _
                                        elmSaveAsDialog, _
                                        UIA_NamePropertyId, _
                                        SAVEASDIALOG_SAVEAS_BUTTON_NAME, _
                                        UIA_ButtonControlTypeId)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
    Loop While elmSaveButton Is Nothing
    '[�ۑ�]�{�^������
    Dim iptn As IUIAutomationInvokePattern
    Set iptn = elmSaveButton.GetCurrentPattern(UIA_InvokePatternId)
    iptn.Invoke
    SaveAsFilenameDialog = True
    Exit Function
ErrorCatch:
    Debug.Print "SaveAsFilenameDialog code: " & Err.Number & " Description: " & Err.Description
    SaveAsFilenameDialog = False
    Exit Function
End Function
'---------------------------------------------------------------------------------------------------------------
'''�_�E�����[�h������A�ʒm�o�[�����
Private Function ClosingNotificationBar(ByRef argUIAuto As CUIAutomation, ByVal hIEWnd As LongPtr) As String
    On Error GoTo ErrorCatch
    Application.StatusBar = "�_�E�����[�h�����҂�"
    '�ʒm�o�[���擾����
    Dim hWndNotification As LongPtr
    '�����J�n���Ԃ��擾
    Dim dateStart As Date
    dateStart = Now()
    Do
        hWndNotification = FindWindowEx(hIEWnd, 0, NOTIFICATION_CLASS_NAME, vbNullString)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        '�^�C���A�E�g���Ԃ��߂��Ă����狭���I������
        If Second(Now() - dateStart) >= SAVEASTIMEOUT Then
            MsgBox "�ʒm�o�[��������" & SAVEASTIMEOUT & "�b�̃^�C���A�E�g���Ԃ𒴉߂��܂����B�����𒆒f���܂�"
            Debug.Print "ClosingNotificationBar: NotificationBar find timeout"
            ClosingNotificationBar = False
            Exit Function
        End If
    Loop Until hWndNotification
    '����ԂɂȂ�܂őҋ@
    Do
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
    Loop Until IsWindowVisible(hWndNotification)
    Dim elmNotificationBar As IUIAutomationElement
    Do
        Set elmNotificationBar = argUIAuto.ElementFromHandle(ByVal hWndNotification)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
    Loop While elmNotificationBar Is Nothing
    '[�ʒm�o�[�̃e�L�X�g]�擾
    Dim elmNotificationText As IUIAutomationElement
    Do
        Set elmNotificationText = GetUIElement(argUIAuto, _
                                                elmNotificationBar, _
                                                UIA_NamePropertyId, _
                                                NOTIFICATION_TEXT, _
                                                UIA_TextControlTypeId)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        Application.StatusBar = "�_�E�����[�h�����҂� " & Second(Now() - dateStart) & " �b�o��..."
    Loop While elmNotificationText Is Nothing
    '�ʒm�o�[�̃e�L�X�g�̓��e���擾���Ă݂�
    Dim vptnNotificationText As IUIAutomationValuePattern
    Set vptnNotificationText = elmNotificationText.GetCurrentPattern(UIA_ValuePatternId)
    Do
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
        Application.StatusBar = vptnNotificationText.CurrentValue
    Loop While InStr(vptnNotificationText.CurrentValue, "�_�E�����[�h�ς�") >= 1
    '�e�L�X�g�o�͂��Ă݂�
    Dim strResultText As String
    strResultText = vptnNotificationText.CurrentValue
'    '�f�o�b�O�o�͂���
'    Debug.Print strResultText
    Dim arrResult() As String
    arrResult = Strings.Split(strResultText, " ")
    '[����]�{�^���擾
    Dim elmCloseButton As IUIAutomationElement
    Do
        Set elmCloseButton = GetUIElement(argUIAuto, _
                                            elmNotificationBar, _
                                            UIA_NamePropertyId, _
                                            NOTIFICATION_CLOSE_BUTTON_NAME, _
                                            UIA_ButtonControlTypeId)
        DoEvents
        Sleep (SLEEP_DEFAULT_MILLISEC)
    Loop While elmCloseButton Is Nothing
    '[����]�{�^������
    Dim iptnClose As IUIAutomationInvokePattern
    Set iptnClose = elmCloseButton.GetCurrentPattern(UIA_InvokePatternId)
    iptnClose.Invoke
    If UBound(arrResult) >= 1 Then
        ClosingNotificationBar = arrResult(0)
        Exit Function
    Else
        Debug.Print "ClosingNotificationBar: ���ʂ̃e�L�X�g�擾���s���Ă���ۂ�"
        ClosingNotificationBar = ""
        Exit Function
    End If
ErrorCatch:
    Debug.Print "ClosingNotificationBar code: " & Err.Number & " Description: " & Err.Description
    ClosingNotificationBar = ""
    Exit Function
End Function

'---------------------------------------------------------------------------------------------------------------
'''uiAuto �w�肳�ꂽ�v���p�e�BID�A�R���g���[���^�C�vID�Ŏw�肳�ꂽ�l�����v�f��Ԃ�
'''return IUIAutomationElement
Private Function GetUIElement(ByVal uiAuto As CUIAutomation, _
                                ByVal elmParent As IUIAutomationElement, _
                                ByVal propertyID As Long, _
                                ByVal propertyValue As Variant, _
                                Optional ByVal ctrlType As Long = 0) _
                                As IUIAutomationElement
                                
    '���������̐ݒ�
    Dim condFirst As IUIAutomationCondition
    Set condFirst = uiAuto.CreatePropertyCondition(propertyID, propertyValue)
    If ctrlType <> 0 Then
        '�R���g���[��ID���w�肳��Ă���ꍇ�͒ǉ��ňȉ������s����
        Dim condSecond As IUIAutomationCondition
        Set condSecond = uiAuto.CreatePropertyCondition(UIA_ControlTypePropertyId, ctrlType)
        'propetryValue ����� ctrlID�����Ɉ�v����������쐬����
        Set condFirst = uiAuto.CreateAndCondition(condFirst, condSecond)
    End If
    Set GetUIElement = elmParent.FindFirst(TreeScope_Subtree, condFirst)
End Function
