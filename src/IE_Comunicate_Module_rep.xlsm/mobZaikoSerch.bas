Attribute VB_Name = "mobZaikoSerch"
Option Explicit
Private Const zaikoSerchURL As String = "http://www.freeway.fuchu.toshiba.co.jp/faz/zaikoSearch/"
Private Const DEBUG_SHOW_IE As Long = &H1                           'IE�̉�ʂ�\��������t���O(1bit)
Private Const ZAIKO_SERCH_DL_TREE As String = "d1d0"                '�݌Ɍ����̃_�E�����[�h�{�^���i������̃y�[�W�j������K�w������
Private Const ZAIKO_SERCH_SCRIPT_TREE As String = "d1d0d"           '�݌Ɍ����̃y�[�W�̃X�N���v�g��������K�w������
Private Const ZAIKO_SERCH_DL_SCRIPT As String = "chkSetChild( document );$('#mainFm').attr('action', '../zaikoInfoSearch/validate/');if(validateSearchCondition()) { document.forms[0].action = '../zaikoInfoSearch/download/'; document.forms[0].submit();}"   '�݌Ɍ����̃_�E�����[�h�{�^���̃X�N���v�g
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''��z�R�[�h�������Ƃ��āA�݌Ɍ����i�̃t�@�C��DL�j���s���v���V�[�W��
'''--------------------------------------------------------------------------------------------------------------
Public Sub ZaikoSerchbyTehaiCode(ByVal strTehaiCode As String)
    Dim getIETest As clsGetIE
    Set getIETest = New clsGetIE
    If strTehaiCode = "" Then
        '��z�R�[�h���w�肳��Ă��Ȃ������甲����
        MsgBox "ZaikoSerchbyTehaiCode: ��z�R�[�h����ł����i�K�{���ځj"
        Exit Sub
    End If
    '�݌ɏ�񌟍��y�[�W��ݒ�
    getIETest.URL = zaikoSerchURL
    'Debug�p
'    isCollect = getIETest.OpenIEwithURL
    '�w�肵��URL��HTML Doc��Dictionary�Ŏ󂯎��e�X�g
    Dim longDebugFlag As Long                   '�f�o�b�O�t���O���Ǘ����邽�߂�Long�ϐ�
'    longDebugFlag = 0 Or DEBUG_SHOW_IE
    If longDebugFlag And DEBUG_SHOW_IE Then
        'IE�\���t���O�������Ă��̂Ńv���p�e�B�ݒ�
        getIETest.Visible = True
    End If
    On Error Resume Next
    Dim dicReturnHTMLDoc As Dictionary
    '�w�肵��URL���S�t���[����HTMLDoc���擾���� Dictionary�`��
    Set dicReturnHTMLDoc = getIETest.ResultHTMLDoc
    If Err.Number <> 0 Then
        '�G���[�������Ă���Ƃ肠���������ɗ��Ă݂�
        DebugMsgWithTime "IETest code: " & Err.Number & " Description: " & Err.Description
    End If
    On Error GoTo ErrorCatch
    '���������z�R�[�h���Z�b�g���Ă��
    SetZaikoSerch_TehaiCode getIETest, strTehaiCode
    '�_�E�����[�h�{�^�����肱
    '�X�N���v�g���ڎ��s�ɐ؂�ւ�(confirm�ׂ��Ȃ������E�E�E�j
    If dicReturnHTMLDoc.Exists(ZAIKO_SERCH_SCRIPT_TREE) Then
        '�݌Ɍ����X�N���v�g�y�[�W�̊K�w�����񂪑��݂���ꍇ�̂ݎ��s����
        Dim docConfirm As HTMLDocument
        Set docConfirm = dicReturnHTMLDoc(ZAIKO_SERCH_SCRIPT_TREE)
        docConfirm.parentWindow.execScript ZAIKO_SERCH_DL_SCRIPT
'        docConfirm.parentWindow.execScript "chkSetChild( document );"
'        docConfirm.parentWindow.execScript "$('#mainFm').attr('action', '../zaikoInfoSearch/validate/');"
'        docConfirm.parentWindow.execScript "if(validateSearchCondition()) { document.forms[0].action = '../zaikoInfoSearch/download/'; document.forms[0].submit();}"
    End If
    '-----------------------------------------------------------------------------------------------------------
    'Save�̏ꍇ�i��{�͂������j
    '�ۑ��t�@�C�����̐����i�t�@�C�����̂݁A�f�B���N�g����Download�̏ꏊ�ɂȂ�͂��Ȃ̂ŉρj
    Dim strFleName As String
    strFleName = "ZaikoSerch" & (Format(Now(), "yyyymmddhhmmss"))
    Dim strResultFilePath As String
    '�ۑ��{�^���������A���ʂ̃t�@�C�������󂯎��
    strResultFilePath = getIETest.DownloadSave_NotificationBar(strFleName)
    '����ŕۑ������t�@�C�������t���p�X�Ŏ擾�ł��Ă���̂ŁA���Ƃ͗��p����̂�
'    MsgBox strResultFilePath
'    Call Application.Workbooks.Open(strResultFilePath)
'    '-----------------------------------------------------------------------------------------------------------
'    'SaveAs�̎��̎g�p���@
'    '�ۑ��t�@�C��������
'    Dim strFilePath As String
'    Dim fsoLink As Scripting.FileSystemObject
'    Set fsoLink = New FileSystemObject
'    strFilePath = fsoLink.BuildPath(fsoLink.GetSpecialFolder(TemporaryFolder), Format(Now(), "yyyymmddhhmmss"))
'    'SaveAs ����
'    Dim strResultFullPath As String
'    strResultFullPath = getIETest.DownloadNotificationBarSaveAs(strFilePath, getIETest.IEInstance.Hwnd)
'    '�A���Ă���Book���J���Ă݂�
'    getIETest.IEInstance.Visible = False
'    Dim wkbNewBook As Workbook
'    Set wkbNewBook = Workbooks.Open(strResultFullPath)
'    wkbNewBook.Activate
'    '�����Ɍ����{�^�����N���b�N���Ă݂�
'    getIETest.IEInstance.document.frames(1).document.frames(0).document.getElementById("kensakuButton").Click
'    Dim localHTMLDoc As HTMLDocument
''    Set localHTMLDoc = dicReturnHTMLDoc(1).frames(0).document
'    Set localHTMLDoc = dicReturnHTMLDoc("t10")
'    Dim elementStrArray() As String
'    elementStrArray = getIETest.getTextArrayByTagName(localHTMLDoc, "A")
'    Cells(getIETest.shRow, getIETest.shColumn).Value = dicReturnHTMLDoc(1).Title
    'Stop
    Set getIETest = Nothing
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "ZaikoSerchbyTehaiCode code: " & Err.Number & " Description: " & Err.Description
    If Not getIETest Is Nothing Then
        Set getIETest = Nothing
    End If
    Exit Sub
End Sub
'''Author Daisuke_Oota
'''GetIE�N���X�������Ƃ��āA�݌Ɍ����̎�z�R�[�h�Ɏw��̕�������Z�b�g����
'''
Private Sub SetZaikoSerch_TehaiCode(ByRef clsargIE As clsGetIE, strargTeheaiCode As String)
    If strargTeheaiCode = "" Then
        Exit Sub
    End If
    'IE�̃C���X�^���X�ɑ΂��č݌Ɍ����̎�z�R�[�h��ݒ肵�Ă��
    clsargIE.IEInstance.document.frames(1).document.frames(0).document.forms(0).Item(ZAIKO_SERCH_TEHAI_CODE_INPUT_BOX_NAME).Value = strargTeheaiCode
    '�����ŕ\�������Ă݂�
    Dim longDebugFrag As Long
    longDebugFrag = longDebugFrag Or DEBUG_SHOW_IE
    If longDebugFrag And DEBUG_SHOW_IE Then
        clsargIE.IEInstance.Visible = True
    End If
End Sub