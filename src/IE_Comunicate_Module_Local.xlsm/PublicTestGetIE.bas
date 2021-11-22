Attribute VB_Name = "PublicTestGetIE"
Option Explicit
Private Const zaikoSerchURL As String = "http://www.freeway.fuchu.toshiba.co.jp/faz/zaikoSearch/"
Private Const DEBUG_SHOW_IE As Long = &H1                   'IE�̉�ʂ�\��������t���O(1bit)
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
    Set dicReturnHTMLDoc = getIETest.ReturnHTMLDocbyURL
    If Err.Number <> 0 Then
        '�G���[�������Ă���Ƃ肠���������ɗ��Ă݂�
        Stop
    End If
    SetZaikoSerch_TehaiCode getIETest, InputBox("��z�R�[�h����͂��ĉ�����")
    Application.Wait 2
    '�����Ɍ����{�^�����N���b�N���Ă݂�
    getIETest.IEInstance.document.frames(1).document.frames(0).document.getElementById("kensakuButton").Click
    Dim localHTMLDoc As HTMLDocument
    Set localHTMLDoc = dicReturnHTMLDoc(1).frames(0).document
    Dim elementStrArray() As String
    elementStrArray = getIETest.getTextArrayByTagName(localHTMLDoc, "A")
    Cells(getIETest.shRow, getIETest.shColumn).Value = dicReturnHTMLDoc(1).Title
    Stop
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