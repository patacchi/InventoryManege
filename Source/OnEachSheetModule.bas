Attribute VB_Name = "OnEachSheetModule"
Option Explicit
'Option Base 1

Public Function Conversion_Target_To_Array(ByRef rangeTargetArg As Range, ByRef vararrCreate As Variant) As Boolean
    'Worksheet_Select_Change�C�x���g�������ɁA�O���[�o���ϐ��ɊJ�n�E�I���s���A�l�̔z���ޔ�������v���O����
    
    Dim timeStart As Double
    '���Ԍv��
    timeStart = timer()
    'Selection�̊J�n�E�ŏI�s�i�[
    longRowStart = rangeTargetArg.Row
    If longRowStart <= constSheetRowStart Then
        longRowStart = constSheetRowStart
    End If
    longRowEnd = rangeTargetArg.Row + rangeTargetArg.Rows.Count - 1
    If longRowEnd < longRowStart Then
        Conversion_Target_To_Array = False
        Exit Function
    End If
    vararrCreate = Range(Cells(longRowStart, constDataStartColumn), Cells(longRowEnd, constDataEndColumn))
    Debug.Print "�����s����" & longRowEnd - longRowStart + 1 & vbCrLf & "�������Ԃ�" & timer() - timeStart
    Conversion_Target_To_Array = True

End Function

Public Sub Btn_Add_All()
    '�S����ǉ��iTodo�j
'    Dim strDatabaseName As String
'    Dim strConnectionString As String
'    Dim bytRetCode As Byte
'    Dim fso As New Scripting.FileSystemObject
'    If Application.EnableEvents = False Then
'        Application.EnableEvents = True
'    End If
'    '�J�����g�f�B���N�g���̈ړ��ƁA�f�[�^�x�[�X���̎擾
'    strDatabaseName = PublicModule.ChcurrentAndReturnDBName
'    '�f�[�^�x�[�X�t�@�C���̑��ݗL���`�F�b�N
'    If fso.FileExists(strDatabaseName) = True Then
'        '�������ꍇ
'        '�f�[�^�ǉ������iTodo)
'
'    Else
'        '���������ꍇ
'        MsgBox "�f�[�^�x�[�X�t�@�C���������̂ŐV�K�쐬���܂�"
'        '�ڑ�������̎擾
'        strConnectionString = PublicModule.GetConnectionString(strDatabaseName)
'        '��f�[�^�x�[�X�̍쐬
'        'bytRetCode = PublicModule.CreateMDB(strDatabaseName, strConnectionString)
'        MsgBox "��̃f�[�^�x�[�X�t�@�C���쐬���������܂���"
'        '�V�K�쐬��A�f�[�^�ǉ������iTodo)
'    End If
'    Set fso = Nothing
End Sub

Public Function Backup_From_To_Data(ByRef rngTarget As Range, ByRef typMaisu() As typMaisuuRireki)
    Dim intProceccCount As Integer  'for���[�v�p�J�E���^�[
    Dim nameFrom As Name
    Dim nameTo As Name
    Dim bytFromColumn As Byte   'From�̗�ԍ�
    Dim bytToColumn As Byte     'To�̗�ԍ�
    'Dim typMaisuLocal() As New typMaisuuRireki
    
    Range(rngTarget.Item(1).Address).Activate
    '�e���O��`�̗�ԍ��擾
    Set nameFrom = GetNameRange(constRirekiFromLabel)
    Set nameTo = GetNameRange(constRirekiToLabel)
    
    bytFromColumn = nameFrom.RefersToRange.Column
    bytToColumn = nameTo.RefersToRange.Column
    
    'typMaisuuRireki�^�Ƀf�[�^�i�[
    For intProceccCount = 1 To rngTarget.Count
        
    Next intProceccCount

End Function

Public Function On_WorkSheet_Change(ByRef rngNewTarget As Range, ByRef rngOldTarget As Range)
    '�����̏����͑啝�Ɍ������K�v�iTodo�j
    '���[�N�V�[�g�Ƀf�[�^�`�F���W���������ꍇ
    '���O�̒�`��Maisuu_Rage�����邩���ׂāA����ꍇ�͕ύX�����͈̔͂����ׂ�
    '���͂��ꂽ�����Ɋ�Â��ăf�[�^�x�[�X��Update(Insert)�𔭍s
    '�f�[�^�x�[�X�ǉ��̍ۂ́A�\�ߓ��͂���f�[�^��z��Ɋi�[���ĎQ�Ɠn�����ǂ��o���܂���
    '���O����`����Ė����ꍇ�͌x���o���ď������f
    '����ɏ����I�������ꍇ�̓Z���̐F��Selection.Interior.ColorIndex = 35 ����i����������[��j
    
    Dim strSQLString() As String
    Dim intErrCode
    Dim rngName As Name
    Dim intTargetRowCount As Integer
    Dim intAddQty As Integer
    Dim strDatabaseName As String
'
'    Set rngName = GetNameRange(constMaisuu_RangeLabel)
'
'    If rngName Is Nothing Then
'        '�����̖��O��`������Ȃ������̂ŏI��
'        MsgBox ActiveSheet.Name & "�V�[�g��" & constMaisuu_RangeLabel & "���O��`��������Ȃ������̂ŏ����𒆎~���܂�"
'        Exit Function
'    End If
'
'    If Intersect(rngNewTarget, rngName.RefersToRange) Is Nothing Then
'        '����͂܂����[�̏ꏊ����Ȃ������̂ŃX���[
'        Exit Function
'    End If
'
'    intTargetRowCount = 0
'    For intTargetRowCount = 1 To rngNewTarget.Count
'        '�ύX�͈͂̍s����For�񂵁A�e�s����Insert���̉�����炤
'        intAddQty = rngNewTarget.Item(intTargetRowCount).Value
'        If intAddQty = 0 Or intAddQty = Empty Then
'            GoTo SkipLoop1
'        End If
'        ReDim strSQLString(intAddQty)
'        strSQLString = PublicModule.CreateInsertSQL(rngNewTarget.Item(intTargetRowCount))
'
'        'If strSQLString = CStr(errcxlDataNothing) Then
'         '   GoTo SkipLoop1
'        'End If
'
'        '�f�[�^�x�[�X�ɒǉ�����
'        '�J�����g�̈ړ��ƃf�[�^�x�[�X���擾
'        strDatabaseName = PublicModule.ChcurrentAndReturnDBName
'        intErrCode = PublicModule.Mdb_RirekiAdd(strDatabaseName, strSQLString)
'        If intErrCode = 0 Then
'            ActiveCell.Interior.ColorIndex = 35
'        End If
'SkipLoop1:
'        Erase strSQLString
'    Next intTargetRowCount
'    Application.StatusBar = ""
'
'    Select Case intErrCode
'    Case 0
'        '����I�������ꍇ
'        On_WorkSheet_Change = 0
'    Case 4
'        '�f�[�^�x�[�X�t�@�C��������Ȃ������ꍇ
'        On_WorkSheet_Change = 4
'    End Select
'
End Function

