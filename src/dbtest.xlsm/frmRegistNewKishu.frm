VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmRegistNewKishu 
   Caption         =   "�V�@��o�^"
   ClientHeight    =   7410
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   12075
   OleObjectBlob   =   "frmRegistNewKishu.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmRegistNewKishu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub btnAlreadyDataSet_Click()
    '���X�g�{�b�N�X�őI������Ă���@��������̂��������ɒ���t����
    Dim intKishuCount As Integer
    If ListBoxAlreadyKishu.ListIndex = -1 Then
        MsgBox "���̃��X�g�̂����ǂꂩ��I��ł��������x�N���b�N���ĉ������B"
        Exit Sub
    End If
    If (Not arrKishuInfoGlobal) = -1 Then
        '����[�΂�kishuinfo���s���s���Ȃ̂Őݒ�
        Call GetAllKishuInfo_Array
    End If
    If boolNoTableKishuRecord Then
        Exit Sub
    End If
    For intKishuCount = 0 To UBound(arrKishuInfoGlobal)
        If ListBoxAlreadyKishu.List(ListBoxAlreadyKishu.ListIndex, 0) = arrKishuInfoGlobal(intKishuCount).KishuHeader Then
            'kishuname����v�����̂ŁA�����Ђ��������Ă���
            txtboxKishuHeader.Text = Len(arrKishuInfoGlobal(intKishuCount).KishuHeader)
            '�@�햼�́AQR�R�[�h�̏��������p���ł���\��������̂ŁA�󔒂̏ꍇ�̂ݓ���
            If txtboxKishuName.Text = "" Then
                txtboxKishuName.Text = arrKishuInfoGlobal(intKishuCount).KishuName
            End If
            txtBoxKishuNickName.Text = arrKishuInfoGlobal(intKishuCount).KishuNickName
            '���������̃g�[�^���͓���������_��
'            txtboxTotalRirekiKetasuu.Text = arrKishuInfoGlobal(intKishuCount).TotalRirekiketa
            txtboxRenbanketasuu.Text = arrKishuInfoGlobal(intKishuCount).RenbanKetasuu
            txtboxKishuHeader.SetFocus
            Exit Sub
        End If
    Next intKishuCount
End Sub
Private Sub btnCancel_Click()
    '�Ƃ肠���������𒆎~����
    MsgBox "�L�����Z���{�^���������ꂽ���߁A�����𒆎~���܂��B"
    boolRegistOK = False
    Unload Me
End Sub
Private Sub btnregistNewKishu_Click()
    Dim longRecordCount As Long
    Dim longMsgBoxReturn As Long
    On Error GoTo ErrorCatch
    If labelKishuHeader.Caption = "" Or txtboxKishuName.Text = "" Or txtboxTotalRirekiKetasuu.Text = "" Or txtboxRenbanketasuu.Text = "" Or txtBoxKishuNickName.Text = "" Then
        MsgBox "�����͉ӏ�������܂��B���͂������Ă�������"
        Exit Sub
    End If
    '�����̕��Əd�����ĂȂ����`�F�b�N���Ă݂�i�ȈՔŁj
    longRecordCount = GetRecordCountSimple(Table_Kishu, Kishu_Header, "LIKE """ & labelKishuHeader.Caption & """")
    If longRecordCount >= 1 Then
        MsgBox "�@��w�b�_�̏d��������悤�ł��B���͓��e���m�F���ĉ������B"
        txtboxKishuHeader.SetFocus
        Exit Sub
    End If
    longRecordCount = GetRecordCountSimple(Table_Kishu, Kishu_KishuName, "LIKE """ & txtboxKishuName.Text & """")
    If longRecordCount >= 1 Then
        MsgBox "�@�햼�ŏd��������悤�ł��B���͓��e���m�F���ĉ������B"
        txtboxKishuName.SetFocus
        Exit Sub
    End If
    longRecordCount = GetRecordCountSimple(Table_Kishu, Kishu_KishuNickname, "LIKE """ & txtBoxKishuNickName.Text & """")
    If longRecordCount >= 1 Then
        MsgBox "�@��ʏ̖��ŏd��������悤�ł��B���͓��e���m�F���ĉ������B"
        txtBoxKishuNickName.SetFocus
        Exit Sub
    End If
    On Error Resume Next
    If Not IsNumeric(CLng(labelRenban.Caption)) Then
        Debug.Print "InNumeric RenbanCaption code: " & Err.Number & " Descriptoin: " & Err.Description
        If Err.Number = 13 Then
            '13=�^����v���܂���
            MsgBox "�A�ԕ����ɐ��l�ȊO���������Ă���悤�ł��B�A�Ԃ̌������m�F���ĉ������B"
        ElseIf Err.Number = 6 Then
            '6 = �I�[�o�[�t���[���܂���
            MsgBox "32bitExcel�ň����鐔���̌����𒴂��Ă��܂��B�A�Ԃ̌������m�F���ĉ������B"
        End If
        txtboxRenbanketasuu.SetFocus
        Exit Sub
    End If
    If Err.Number <> 0 Then
        MsgBox "�A�ԕ����ɐ��l�ȊO���������Ă���悤�ł��B�A�Ԃ̌������m�F���ĉ������B"
        txtboxRenbanketasuu.SetFocus
        Exit Sub
    End If
    '�A�ԁA�@��w�b�_�������g�[�^�����������ĂȂ����ǂ���
    If CInt((txtboxKishuHeader.Text) + CInt(txtboxRenbanketasuu.Text)) > CInt(txtboxTotalRirekiKetasuu.Text) Then
        MsgBox "�����w�b�_�̌����ƘA�Ԍ����̍��v�������̃g�[�^�������𒴂��Ă��܂��B"
        txtboxKishuHeader.SetFocus
        Exit Sub
    End If
    On Error GoTo ErrorCatch
    If CByte(txtboxTotalRirekiKetasuu.Text) > constMaxRirekiKetasuu Then
        longMsgBoxReturn = MsgBox(prompt:="�����̌����� " & constMaxRirekiKetasuu & "���𒴂��Ă��܂����A���s���܂����H", Buttons:=vbYesNo)
        If longMsgBoxReturn = vbNo Then
            boolRegistOK = False
            Unload Me
            Exit Sub
        End If
    End If
    boolRegistOK = registNewKishu_to_KishuTable(labelKishuHeader.Caption, txtboxKishuName.Text, txtBoxKishuNickName.Text, _
                    CByte(txtboxTotalRirekiKetasuu.Text), CByte(txtboxRenbanketasuu.Text))
    If boolRegistOK Then
        'noKishu�t���O�������Ă���Ђ����߂�
        boolNoTableKishuRecord = False
        '�O���[�o����KishuInfo���X�V���Ă��
        Call GetAllKishuInfo_Array
        Unload Me
        Exit Sub
    Else
        MsgBox "�@��o�^��ƂŃG���[���������܂���"
        Debug.Print "�@��o�^�t���ONG�ɂ��I��"
        Unload Me
        Exit Sub
    End If
    Exit Sub
ErrorCatch:
    MsgBox "�@��o�^���ɃG���[�����������悤�ł��B�����𒆎~���܂�"
    Debug.Print "btnRegistNewKishu_click code: " & Err.Number & " Description: " & Err.Description
    boolRegistOK = False
    Unload Me
    Exit Sub
End Sub
Private Sub txtboxKishuHeader_Change()
    '�@��w�b�_�̌������ω�������A���̃��x���ɗ����̍��[����̎w�蕶���������Ă��
    Dim intStringCount As Integer
    If txtboxKishuHeader.Text = "" Then
        intStringCount = 0
    Else
        intStringCount = CInt(txtboxKishuHeader.Text)
    End If
    If intStringCount >= Len(strRegistRireki) Then
        intStringCount = Len(strRegistRireki)
    End If
    labelKishuHeader.Caption = Left(strRegistRireki, intStringCount)
End Sub
Private Sub txtboxRenbanketasuu_Change()
    Dim intStringCount As Integer
    If txtboxRenbanketasuu.Text = "" Then
        intStringCount = 0
    Else
        intStringCount = CInt(txtboxRenbanketasuu.Text)
    End If
    If intStringCount >= Len(strRegistRireki) Then
        intStringCount = Len(strRegistRireki)
    End If
    labelRenban.Caption = Right(strRegistRireki, intStringCount)
End Sub
Private Sub txtboxKishuHeader_KeyPress(ByVal KeyAscii As MSForms.ReturnInteger)
    If Chr(KeyAscii) < "0" Or Chr(KeyAscii) > "9" Then
        KeyAscii = 0
    End If
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
    Dim dbKishuList As clsSQLiteHandle
    strRireki = strRegistRireki
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
    '�����@�탊�X�g�{�b�N�X�̏�����
    If Not IsTableExist(Table_Kishu) Then
        MsgBox "�@��e�[�u��������܂���B�V�K�쐬���܂�"
        InitialDBCreate
    End If
    Set dbKishuList = New clsSQLiteHandle
    '�@��e�[�u�����AKishuName�AKishuNickname���Ƃ��Ă��ĕ\�����Ă��
    dbKishuList.SQL = "SELECT " & Kishu_Header & " as �@��w�b�_ , " & _
                        Kishu_KishuName & " as �@�햼 , " & _
                        Kishu_KishuNickname & " as �ʏ̖� FROM " & Table_Kishu
    Call dbKishuList.DoSQL_No_Transaction
    ListBoxAlreadyKishu.ColumnCount = 3
    ListBoxAlreadyKishu.List = dbKishuList.RS_Array(boolPlusTytle:=True)
    Set dbKishuList = Nothing
    '�����̃g�[�^��������ݒ肵�A������ҏW�s��
    If strRegistRireki = "" Then
        txtboxTotalRirekiKetasuu.Text = 0
    Else
        txtboxTotalRirekiKetasuu.Text = CStr(Len(strRegistRireki))
    End If
    txtboxTotalRirekiKetasuu.Enabled = False
    'QR�R�[�h����ǂݎ�����}�Ԃ�����ꍇ�́A�@�햼�ɓK�p
    If Not strQRZuban = "" Then
        txtboxKishuName.Text = strQRZuban
    End If
    '�����@��o�^����ĂȂ����炱���ɗ����񂾂낤�ƌ�������
    boolRegistOK = False
    MsgBox "�@�킪�o�^����Ă��Ȃ������悤�Ȃ̂œo�^��ʂɈڍs���܂��B"
End Sub
Private Sub UserForm_Terminate()
    '�I������
    strQRZuban = ""
    strRegistRireki = ""
End Sub