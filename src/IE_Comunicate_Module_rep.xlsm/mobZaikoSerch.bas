Attribute VB_Name = "mobZaikoSerch"
Option Explicit
Private Const zaikoSerchURL As String = "http://www.freeway.fuchu.toshiba.co.jp/faz/zaikoSearch/"
Private Const DEBUG_SHOW_IE As Long = &H1                   'IE�̉�ʂ�\��������t���O(1bit)
Private Const ZAIKO_SERCH_DL_TREE As String = "d1d0"        '�݌Ɍ����̃_�E�����[�h�{�^���i������̃y�[�W�j������K�w������
'private const ZAIKO_SERCH_SCRIPT_TREE as String = "d1d0d"
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''IE��������Ƃ��Ă��āi�V�[�g�ɏ����o���j�e�X�g���W���[��
'''--------------------------------------------------------------------------------------------------------------
Public Sub IETest()
    Dim getIETest As clsGetIE
    Set getIETest = New clsGetIE
    '�݌ɏ�񌟍��y�[�W��ݒ�
    getIETest.URL = zaikoSerchURL
'    getIETest.URL = "file:///C:/Users/q3005sbe/AppData/Local/Rep/Backup/FrameSampe.htm"
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
    Set dicReturnHTMLDoc = getIETest.ResultHTMLDoc
    If Err.Number <> 0 Then
        '�G���[�������Ă���Ƃ肠���������ɗ��Ă݂�
        DebugMsgWithTime "IETest code: " & Err.Number & " Description: " & Err.Description
    End If
'    SetZaikoSerch_TehaiCode getIETest, InputBox("��z�R�[�h����͂��ĉ�����")
    '���������z�R�[�h���ꎞ�I��shIEData.cells(4,3)�ɋL�����邱�ƂƂ���
    SetZaikoSerch_TehaiCode getIETest, CStr(shIEData.Cells(4, 3).Value)
    Application.Wait 2
    '�S�t���[�����w�肵���^�O��HTML Document������Ă���
    Dim dicTagElms As Dictionary
    Set dicTagElms = getIETest.GetHTMLdicBydicHTMLDocandTagName(dicReturnHTMLDoc, "Input")
    '�_�E�����[�h�{�^���������Ă݂�
    Dim docZaikoDLButton As HTMLDocument
    If dicReturnHTMLDoc.Exists(ZAIKO_SERCH_DL_TREE) Then
        '����dic�Ƀ_�E�����[�h�{�^���̊K�w�����񂪂���ꍇ�̂ݎ��s
        Set docZaikoDLButton = dicReturnHTMLDoc(ZAIKO_SERCH_DL_TREE)
    End If
    '�_�E�����[�h�{�^�����肱
    Dim docConfirm As HTMLDocument
    Set docConfirm = dicReturnHTMLDoc("d1d0d")
    docConfirm.parentWindow.execScript "chkSetChild( document );"
    docConfirm.parentWindow.execScript "$('#mainFm').attr('action', '../zaikoInfoSearch/validate/');"
    docConfirm.parentWindow.execScript "if(validateSearchCondition()) { document.forms[0].action = '../zaikoInfoSearch/download/'; document.forms[0].submit();}"
'    Stop
'    Sleep 3000
    '�ۑ��t�@�C��������
    Dim strFilePath As String
    Dim fsoLink As Scripting.FileSystemObject
    Set fsoLink = New FileSystemObject
    strFilePath = fsoLink.BuildPath(fsoLink.GetSpecialFolder(TemporaryFolder), Format(Now(), "yyyymmddhhmmss"))
    'SaveAs ����
    Dim strResultFullPath As String
    strResultFullPath = getIETest.DownloadNotificationBarSaveAs(strFilePath, getIETest.IEInstance.hwnd)
    '�A���Ă���Book���J���Ă݂�
    getIETest.IEInstance.Visible = False
    Dim wkbNewBook As Workbook
    Set wkbNewBook = Workbooks.Open(strResultFullPath)
    wkbNewBook.Activate
'    '�����Ɍ����{�^�����N���b�N���Ă݂�
'    getIETest.IEInstance.document.frames(1).document.frames(0).document.getElementById("kensakuButton").Click
'    Dim localHTMLDoc As HTMLDocument
''    Set localHTMLDoc = dicReturnHTMLDoc(1).frames(0).document
'    Set localHTMLDoc = dicReturnHTMLDoc("t10")
'    Dim elementStrArray() As String
'    elementStrArray = getIETest.getTextArrayByTagName(localHTMLDoc, "A")
    Cells(getIETest.shRow, getIETest.shColumn).Value = dicReturnHTMLDoc(1).Title
    'Stop
    Set getIETest = Nothing
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