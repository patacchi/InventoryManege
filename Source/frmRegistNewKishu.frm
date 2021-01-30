VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmRegistNewKishu 
   Caption         =   "�V�@��o�^�i���{����͕s�j"
   ClientHeight    =   7410
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8805.001
   OleObjectBlob   =   "frmRegistNewKishu.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmRegistNewKishu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub btnRegistNewKishu_Click()
    Dim boolRegistOK As Boolean
    If txtboxKishuHeader.Text = "" Or txtboxKishuName.Text = "" Or txtboxTotalRirekiKetasuu.Text = "" Or txtboxRenbanketasuu.Text = "" Or txtBoxKishuNickName.Text = "" Then
        MsgBox "�����͉ӏ�������܂��B���͂������Ă�������"
        Exit Sub
    End If
    
    boolRegistOK = registNewKishu(txtboxKishuHeader.Text, txtboxKishuName.Text, txtBoxKishuNickName.Text, _
                    CByte(txtboxTotalRirekiKetasuu.Text), CByte(txtboxRenbanketasuu.Text))
    
End Sub

Private Sub txtboxRenbanketasuu_Change()
    Dim intStringCount As Integer
    intStringCount = CInt(txtboxRenbanketasuu.Text)
    If intStringCount >= Len(frmJobNumberInput.txtboxStartRireki.Text) Then
        intStringCount = Len(frmJobNumberInput.txtboxStartRireki.Text)
    End If
    labelRenban.Caption = Right(frmJobNumberInput.txtboxStartRireki.Text, intStringCount)

End Sub

Private Sub txtboxRenbanketasuu_KeyPress(ByVal KeyAscii As MSForms.ReturnInteger)
    If Chr(KeyAscii) < "0" Or Chr(KeyAscii) > "9" Then
        KeyAscii = 0
    End If
End Sub

Private Sub UserForm_Initialize()
    '�����������Ƃ��āE�E�E
    Dim strRireki As String
    Dim byteLocalCounter As Byte
    Dim strUpperRubi As String  '�����㕔�\���p���r
    Dim strMiddle As String     '����^��
    Dim strLowerRubi As String  '�����������r
    Dim strHantei As String '���𔻒�p�e�L�X�g�A�㉺�ɐ����̃��r��
    strRireki = frmJobNumberInput.txtboxStartRireki.Text
    strMiddle = ""
    strHantei = ""
    strUpperRubi = ""
    strLowerRubi = ""
    '�܂��͍���1�ŉE�����������ɂȂ郋�r���A���łɐ^�񒆂�
    For byteLocalCounter = 1 To Len(strRireki)
        strUpperRubi = strUpperRubi & byteLocalCounter
        strUpperRubi = strUpperRubi & Space(3 - Len(CStr(byteLocalCounter)))
        strMiddle = strMiddle & Mid(strRireki, byteLocalCounter, 1)
        strMiddle = strMiddle & Space(2)
    Next byteLocalCounter
    
    strUpperRubi = RTrim(strUpperRubi)
    strMiddle = RTrim(strMiddle)
    byteLocalCounter = Len(strRireki)
    '���ɉ����̃��r��
    Do While byteLocalCounter >= 1
        strLowerRubi = strLowerRubi & byteLocalCounter
        strLowerRubi = strLowerRubi & Space(3 - Len(CStr(byteLocalCounter)))
        byteLocalCounter = byteLocalCounter - 1
    Loop
    strLowerRubi = RTrim(strLowerRubi)
    '����p�e�L�X�g����
    strHantei = strUpperRubi & vbCrLf & strMiddle & vbCrLf & strLowerRubi
    txtboxHanteiRireki = strHantei
    
    txtboxTotalRirekiKetasuu.Text = Len(strRireki)

End Sub
