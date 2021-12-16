VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmSQLTest 
   Caption         =   "SQL�e�X�g"
   ClientHeight    =   8865.001
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   13785
   OleObjectBlob   =   "frmSQLTest.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmSQLTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub btnExportCSV_Click()
    'CSV�o��
    Dim strFilePath As String
    strFilePath = Application.GetSaveAsFilename(InitialFileName:="\\PC24929-tdms\DBLearn\Test\CSV_Output\", filefilter:="CSV�t�@�C��(*.csv),*.csv")
    If strFilePath = "False" Then
        DebugMsgWithTime "btnExportCSV�ŃL�����Z���������ꂽ"
        Exit Sub
    End If
    Call OutputArrayToCSV(Me.listBoxSQLResult.List, strFilePath)
    Exit Sub
End Sub
'''Author Daisuke oota 2021_10_29
''' �P�̂Ńe�X�g�������v���V�[�W�����L�q
'''
Private Sub btnSingleTest_Click()
''''�r�b�g�t���O�e�X�g
''''32�r�b�g�܂ŏ��ԂɃt���O�𗧂ĂāALong�łǂ��\������邩
'
'    Dim longFlag As Long
'    Dim intBitCount As Integer
'    Dim logBeki As Double
'    longFlag = 0
'    For intBitCount = 0 To 30
'        longFlag = 0 Or (2 ^ intBitCount)
'        logBeki = Log(longFlag) / Log(2#)
'        DebugMsgWithTime (vbCrLf & intBitCount & "bit" & vbCrLf & longFlag & vbCrLf & logBeki)
'    Next intBitCount
'�_�E�����[�h�p�X�擾
    MsgBox GetDownloadPath
End Sub
'''Author Daisuke Oota 2021_10_18
'''�p�����[�^�o�C���h���g�p���邩�ǂ���
'''True�ɂȂ�����p�����[�^���̓{�b�N�X��\��������AFalse�ɂȂ��������
Private Sub chkBoxUseParm_Change()
    Select Case chkBoxUseParm.Value
    Case True
        '�p�����[�^�o�C���h���g�p����ꍇ
        txtBoxParmText1.Visible = True
        txtBoxParmText2.Visible = True
        txtBoxParmText3.Visible = True
    Case False
        '�p�����[�^�o�C���h���g�p���Ȃ��ꍇ
        txtBoxParmText1.Visible = False
        txtBoxParmText2.Visible = False
        txtBoxParmText3.Visible = False
    End Select
End Sub
'''Author Daisuke oota 2021_10_18
'''�e�L�X�g�{�b�N�X�̒l���p�����[�^�o�C���h�Ɏg�p����u�����X�g�iDictionary�j���쐬����
'''---------------------------------------------------------------------------------------------------
Private Function CreateParmDic() As Dictionary
    If txtBoxParmText1.Text = "" And txtBoxParmText2.Text = "" And txtBoxParmText3.Text = "" Then
        MsgBox "�p�����[�^���̓e�L�X�g�{�b�N�X���S�ċ�ł�"
        Exit Function
    End If
    Dim localDic As Dictionary
    Set localDic = New Dictionary
    localDic.Add 0, txtBoxParmText1.Text
    localDic.Add 1, txtBoxParmText2.Text
    localDic.Add 2, txtBoxParmText3.Text
    Set CreateParmDic = localDic
    Exit Function
End Function
Private Sub UserForm_Activate()
    '���T�C�Y�@�\�ǉ�
    Call FormResize
End Sub
Private Sub UserForm_Initialize()
    '�f�t�H���gDB�f�B���N�g����DB�t�@�C�������E���Ă���
    Dim dbDefault As clsADOHandle
    Set dbDefault = New clsADOHandle
    txtBoxDefaultDBDirectory.Text = dbDefault.DBPath
    txtBoxDefaultDBFile.Text = dbDefault.DBFileName
End Sub
Private Sub UserForm_Resize()
    '�t�H�[�����T�C�Y���ɁA���̃��X�g�{�b�N�X���T�C�Y�ύX���Ă��
    Dim intListHeight As Integer
    Dim intListWidth As Integer
    intListHeight = Me.InsideHeight - listBoxSQLResult.Top * 2
    intListWidth = Me.InsideWidth - (txtboxSQLText.Left * 2) - txtboxSQLText.Width - (listBoxSQLResult.Left - txtboxSQLText.Width - txtboxSQLText.Left)
    If (intListHeight > 0 And intListWidth > 0) Then
        listBoxSQLResult.Height = intListHeight
        listBoxSQLResult.Width = intListWidth
    End If
End Sub
Private Sub btnBulkDataInput_Click()
    Dim strSQL
    Randomize
'    frmBulkInsertTest.Show
    '����͈̗͂����̔����̂�����
    'Int((�͈͏���l - �͈͉����l + 1) * Rnd + �͈͉����l)
End Sub
Private Sub btnSQLGo_Click()
    '�G���[�`�F�b�N�Ƃ��قƂ�ǂȂ�
    '�e�L�X�g�{�b�N�X�ɓ��ꂽSQL�����s����t�H�[�����ۂ���
    If txtboxSQLText.Text = "" Then
        MsgBox "�󔒂͂�����ƁE�E�E"
        Exit Sub
    End If
    Dim varRetValue As Variant
    Dim strWidths As String
    Dim isDBFile As Boolean
''    isDBFile = IsDBFileExist
'    If Not isDBFile Then
'        'DB�t�@�C���쐬�E�m�F���ɉ����������񂾂ˁE�E
'        DebugMsgWithTime "DB�t�@�C���쐬�E�m�F���ɉ���������"
'        Exit Sub
'    End If
    Dim isCollect As Boolean
    Dim dbTest As clsADOHandle
    Set dbTest = New clsADOHandle
    If chkBoxUseParm.Value Then
        '�p�����[�^�o�C���h�L��̏ꍇ
        Dim sqlBc As clsSQLStringBuilder
        Set sqlBc = New clsSQLStringBuilder
        Dim dicParm As Dictionary
        Set dicParm = CreateParmDic
        isCollect = dbTest.Do_SQL_with_NO_Transaction(sqlBc.ReplaceParm(txtboxSQLText.Text, dicParm))
        Set dicParm = Nothing
        Set sqlBc = Nothing
    Else
        isCollect = dbTest.Do_SQL_with_NO_Transaction(txtboxSQLText.Text)
    End If
    If isCollect Then
        If chkboxNoTitle.Value = True Then
            '�^�C�g���Ȃ�����]�̏ꍇ�͂�����
'            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=False)
            varRetValue = dbTest.RS_Array
            strWidths = GetColumnWidthString(varRetValue, 0)
        Else
            '�f�t�H���g�̓^�C�g������
'            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=True)
            varRetValue = dbTest.RS_Array
            strWidths = GetColumnWidthString(varRetValue, 1)
        End If
    Else
        '�G���[���������ꍇ�̏����E�E�E�Ȃ񂾂���
        '�G���[���b�Z�[�W�����̂܂ܕ\������΂����̂ł́E�E�E
        If chkboxNoTitle.Value = True Then
            '�^�C�g���Ȃ�����]�̏ꍇ�͂�����
'            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=False)
            strWidths = GetColumnWidthString(varRetValue, 0)
        Else
            '�f�t�H���g�̓^�C�g������
'            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=True)
            strWidths = GetColumnWidthString(varRetValue, 1)
        End If
    End If
    If VarType(varRetValue) = vbEmpty Then
        listBoxSQLResult.Clear
        listBoxSQLResult.AddItem "�f�[�^�Ȃ�"
        Exit Sub
    End If
    If chkBoxMaxLength.Value = True Then
        '�ő啶����������������������
        strWidths = GetColumnWidthString(varRetValue, boolMaxLengthFind:=True)
    End If
    With listBoxSQLResult
        .ColumnCount = UBound(varRetValue, 2) - LBound(varRetValue, 2) + 1
        .ColumnWidths = strWidths
        '.List = Join(varRetValue)
        .List = varRetValue
        '.AddItem (varRetValue(1)(1))
    End With
End Sub
Private Sub listBoxSQLResult_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    '���X�g�_�u���N���b�N������N���b�v�{�[�h�ɃR�s�[���Ă݂��悤
    Dim objDataObj As DataObject
    Dim intCounterColumn As Integer
    Dim strListText As String
    Set objDataObj = New DataObject
        objDataObj.SetText (listBoxSQLResult.List(listBoxSQLResult.ListIndex))
        objDataObj.PutInClipboard
        strListText = ""
        For intCounterColumn = 0 To listBoxSQLResult.ColumnCount - 1
            If IsNull(listBoxSQLResult.List(listBoxSQLResult.ListIndex, intCounterColumn)) Then
                'Null�̏ꍇ��NULL���ē���Ă�낤
                strListText = strListText & " NULL"
            Else
                strListText = strListText & " " & CStr(listBoxSQLResult.List(listBoxSQLResult.ListIndex, intCounterColumn))
            End If
        Next intCounterColumn
        LTrim (strListText)
        MsgBox strListText
        DebugMsgWithTime strListText
End Sub