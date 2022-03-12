Attribute VB_Name = "modZaikoSerch"
Option Explicit
Private Const zaikoSerchURL As String = "http://www.freeway.fuchu.toshiba.co.jp/faz/zaikoSearch/"
Private Const DEBUG_SHOW_IE As Long = &H1                           'IE�̉�ʂ�\��������t���O(1bit)
Private Const ZAIKO_SERCH_DL_TREE As String = "d1d0"                '�݌Ɍ����̃_�E�����[�h�{�^���i������̃y�[�W�j������K�w������
Private Const ZAIKO_SERCH_SCRIPT_TREE As String = "d1d0d"           '�݌Ɍ����̃y�[�W�̃X�N���v�g��������K�w������
Private Const ZAIKO_SERCH_DL_SCRIPT As String = "chkSetChild( document );$('#mainFm').attr('action', '../zaikoInfoSearch/validate/');if(validateSearchCondition()) { document.forms[0].action = '../zaikoInfoSearch/download/'; document.forms[0].submit();}"   '�݌Ɍ����̃_�E�����[�h�{�^���̃X�N���v�g
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''��z�R�[�h�������Ƃ��āA�݌Ɍ����i�̃t�@�C��DL�j���s���ADL�����t�@�C�����̃t���p�X��Ԃ�
'''�߂�l string    DL�����t�@�C���̃t���p�X
'''parms
'''IEZaikoSerch                     �C���X�^���X�����L���ăR���X�g���N�^�ł������̂�����������
'''optional strargReturnFileName
'''--------------------------------------------------------------------------------------------------------------
Public Function ZaikoSerchbyTehaiCode(ByVal strTehaiCode As String, _
    ByRef clsGetieZaikoSerch As clsGetIE, Optional strargReturnFileName As String) As String
    '�N���X�����m�F
    If clsGetieZaikoSerch Is Nothing Then
        '�N���X����������������Ă��Ȃ�
        DebugMsgWithTime "ZaikoSerhbyTehaiCode: Warning! clsGetIE instance empy. will delay...."
        Set clsGetieZaikoSerch = New clsGetIE
    End If
    '��z�R�[�h�󕶎��͂��肦��̂ő��s����
'    If strTehaiCode = "" Then
'        '��z�R�[�h���w�肳��Ă��Ȃ������甲����
'        MsgBox "ZaikoSerchbyTehaiCode: ��z�R�[�h����ł����i�K�{���ځj"
'        Exit Function
'    End If
    '�݌ɏ�񌟍��y�[�W��ݒ�
    clsGetieZaikoSerch.URL = zaikoSerchURL
    Dim longDebugFlag As Long                   '�f�o�b�O�t���O���Ǘ����邽�߂�Long�ϐ�
'    longDebugFlag = 0 Or DEBUG_SHOW_IE
'    If longDebugFlag And DEBUG_SHOW_IE Then
'        'IE�\���t���O�������Ă��̂Ńv���p�e�B�ݒ�
'        clsGetieZaikoSerch.Visible = True
'    End If
    On Error Resume Next
    Dim dicReturnHTMLDoc As Dictionary
    If Not dicReturnHTMLDoc Is Nothing Then
        '2�T�ڈȍ~�̓C���X�^���X�ė��p���邽�߁ADictionary�ɒ��g���������܂܂ɂȂ��Ă���
        'RemoveAll�������Ă݂�
        '�_���������ꍇ�͂P�T���Ƃ�Nothing�ɂ���悤��
        dicReturnHTMLDoc.RemoveAll
    End If
    '�w�肵��URL���S�t���[����HTMLDoc���擾���� Dictionary�`��
    Set dicReturnHTMLDoc = clsGetieZaikoSerch.ResultHTMLDoc
    If Err.Number <> 0 Then
        '�G���[�������Ă���Ƃ肠���������ɗ��Ă݂�
        DebugMsgWithTime "ZaikoSerchbyTehaiCode code: " & Err.Number & " Description: " & Err.Description
    End If
    On Error GoTo ErrorCatch
    '���������z�R�[�h���Z�b�g���Ă��
    SetZaikoSerch_TehaiCode clsGetieZaikoSerch, strTehaiCode
    '�_�E�����[�h�{�^�����肱
    '�X�N���v�g���ڎ��s�ɐ؂�ւ�(confirm�ׂ��Ȃ������E�E�E�j
    If dicReturnHTMLDoc.Exists(ZAIKO_SERCH_SCRIPT_TREE) Then
        '�݌Ɍ����X�N���v�g�y�[�W�̊K�w�����񂪑��݂���ꍇ�̂ݎ��s����
        Dim docConfirm As HTMLDocument
        If Not docConfirm Is Nothing Then
            '���̎��_��docConfirm��Nothing����Ȃ������ꍇ
'            docConfirm.Close
            docConfirm.Clear
        End If
        Set docConfirm = dicReturnHTMLDoc(ZAIKO_SERCH_SCRIPT_TREE)
        docConfirm.parentWindow.execScript ZAIKO_SERCH_DL_SCRIPT
    End If
    '-----------------------------------------------------------------------------------------------------------
    'Save�̏ꍇ�i��{�͂������j
    '�ۑ��t�@�C�����̐����i�t�@�C�����̂݁A�f�B���N�g����Download�̏ꏊ�ɂȂ�͂��Ȃ̂ŉρj
    If strargReturnFileName = "" Then
        '�ۑ��t�@�C�������w�肳��Ȃ������ꍇ
        'TehaiCode_yyyy_mm_dd_HH_MM_SS_fff
        strargReturnFileName = strTehaiCode & GetTimeForFileNameWithMilliSec
    End If
    Dim strResultFilePath As String
    '�ۑ��{�^���������A���ʂ̃t�@�C�������󂯎��
    strResultFilePath = clsGetieZaikoSerch.DownloadSave_NotificationBar(strargReturnFileName)
    ZaikoSerchbyTehaiCode = strResultFilePath
'    '-----------------------------------------------------------------------------------------------------------
'    'SaveAs�̎��̎g�p���@
'    '�ۑ��t�@�C��������
'    Dim strFilePath As String
'    Dim fsoLink As Scripting.FileSystemObject
'    Set fsoLink = New FileSystemObject
'    strFilePath = fsoLink.BuildPath(fsoLink.GetSpecialFolder(TemporaryFolder), Format(Now(), "yyyymmddhhmmss"))
'    'SaveAs ����
'    Dim strResultFullPath As String
'    strResultFullPath = clsgetiezaikoserch.DownloadNotificationBarSaveAs(strFilePath, clsgetiezaikoserch.IEInstance.Hwnd)
'    '�A���Ă���Book���J���Ă݂�
'    clsgetiezaikoserch.IEInstance.Visible = False
'    Dim wkbNewBook As Workbook
'    Set wkbNewBook = Workbooks.Open(strResultFullPath)
'    wkbNewBook.Activate
'    '�����Ɍ����{�^�����N���b�N���Ă݂�
'    clsgetiezaikoserch.IEInstance.Document.frames(1).Document.frames(0).Document.getElementById("kensakuButton").Click
'    Dim localHTMLDoc As HTMLDocument
''    Set localHTMLDoc = dicReturnHTMLDoc(1).frames(0).Document
'    Set localHTMLDoc = dicReturnHTMLDoc("t10")
'    Dim elementStrArray() As String
'    elementStrArray = clsgetiezaikoserch.getTextArrayByTagName(localHTMLDoc, "A")
'    Cells(clsgetiezaikoserch.shRow, clsgetiezaikoserch.shColumn).Value = dicReturnHTMLDoc(1).Title
'    Set clsGetieZaikoSerch = Nothing
    Exit Function
ErrorCatch:
    DebugMsgWithTime "ZaikoSerchbyTehaiCode code: " & Err.Number & " Description: " & Err.Description
    '�N���X�ϐ��̓C���X�^���X�����L����̂Ōʂɉ����NG
'    If Not clsGetieZaikoSerch Is Nothing Then
'        Set clsGetieZaikoSerch = Nothing
'    End If
    Exit Function
End Function
'''Author Daisuke_Oota
'''GetIE�N���X�������Ƃ��āA�݌Ɍ����̎�z�R�[�h�Ɏw��̕�������Z�b�g����
'''args
Private Sub SetZaikoSerch_TehaiCode(ByRef clsargIE As clsGetIE, strargTeheaiCode As String)
    On Error GoTo ErrorCatch
    If strargTeheaiCode = "" Then
'        Exit Sub
        '�Ǘ��ێw�肵����ł̎�z�R�[�h�󔒂͂��蓾��̂ŁA�_�C�A���O���o���ď����𕪊򂷂�
        Dim resultFullDL As VbMsgBoxResult
        resultFullDL = MsgBox("��z�R�[�h���w�肳��܂���ł����B�S�Ă̎�z�R�[�h�̃t�@�C����DL���܂����H", vbYesNo)
        If resultFullDL = vbNo Then
            'NO�A�������������ꂽ
            MsgBox "�����𒆒f���܂�"
            Exit Sub
        End If
    End If
    'IE�C���X�^���X�i�݌Ɍ����y�[�W�j�̊Ǘ��ۂɑ΂��āuW�v��ݒ肵�Ă��
    '���� Index = 11 �� MS�u W �Ȃ̂ł�����I�����Ă��A��ʏ�̕\���͕ς���Ă��Ȃ����A�f�[�^��͔��f����Ă���͗l
    clsargIE.IEInstance.Document.frames(1).Document.frames(0).Document.forms(0).Item(ZAIKO_SERTH_KANRI_KA_INPUT_BOX_NAME).selectedIndex = 11
    'IE�̃C���X�^���X�ɑ΂��č݌Ɍ����̎�z�R�[�h��ݒ肵�Ă��
    clsargIE.IEInstance.Document.frames(1).Document.frames(0).Document.forms(0).Item(ZAIKO_SERCH_TEHAI_CODE_INPUT_BOX_NAME).Value = strargTeheaiCode
#If DebugShowIE Then
    '�����t���R���p�C�������ŕ\������ݒ�ɂȂ��Ă�����\�����Ă��
    clsargIE.IEInstance.Visible = True
#End If
Exit Sub
ErrorCatch:
    DebugMsgWithTime "SetZaikoSerch_TehaiCode: " & Err.Number & " Description: " & Err.Description
    Exit Sub
End Sub