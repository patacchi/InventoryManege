VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsEnum"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'''Enum�̒l���當����������o�����߂̃N���X
'''Enum����Dictionary�����AEnum�̒l���L�[�Ƃ��āA���ڕ�����𖄂ߍ��ށi�ł���Α���Const�Œ�`����j
'''
Option Explicit
Private dicDBFileExetension As Dictionary
Private dicAccdbDataType As Dictionary
Private dicCATHeaderField As Dictionary
Private dicCATDescriptionField As Dictionary
Private dicCATDetailField As Dictionary
Private dicCATSpecialField As Dictionary
Private dicCATMasterDescriptionField As Dictionary
Private dicCATMasterDetailField As Dictionary
Private dicMasterDigitField As Dictionary
Private dicCATTmpField As Dictionary
Private dicINVMasterParts As Dictionary
Private dicSHZaikoParts As Dictionary
Private Sub Class_Initialize()
    Call Initial_Valueset
End Sub
Private Sub Initial_Valueset()
    '�N���X����������Enum����Dictionary�ɒl������
''DB�t�@�C���̗񋓑�
'Public Enum DB_file_exetension
'    accdb_dext = 1
'    xlam_dext = 2
'    xlsm_dext = 3
'    xlsx_dext = 4
'    xlsb_dext = 5
'    csv_dext = 6
'End Enum
    If dicDBFileExetension Is Nothing Then
        Set dicDBFileExetension = New Dictionary
    End If
    dicDBFileExetension.Add DB_file_exetension.accdb_dext, PublicConst.DB_FILE_EXETENSION_ACCDB
    dicDBFileExetension.Add DB_file_exetension.xlam_dext, PublicConst.DB_FILE_EXETENSION_XLAM
    dicDBFileExetension.Add DB_file_exetension.xlsm_dext, PublicConst.DB_FILE_EXETENSION_XLSM
    dicDBFileExetension.Add DB_file_exetension.xlsx_dext, PublicConst.DB_FILE_EXETENSION_XLSX
    dicDBFileExetension.Add DB_file_exetension.xlsb_dext, PublicConst.DB_FILE_EXETENSION_XLSB
    dicDBFileExetension.Add DB_file_exetension.xls_dext, PublicConst.DB_FILE_EXETENSION_XLS
    dicDBFileExetension.Add DB_file_exetension.csv_dext, PublicConst.DB_FILE_EXETENSION_CSV
'Public Enum ACCDB_Data_Type
'    [Text] = 1
'    [INTEGER] = 2
'    [BIT] = 3
'    [Boolean] = 3
'    [COUNTER] = 4
'    [AUTOINCREMENT] = 4
'    [Decimal] = 5
'    Single_typ = 6
'    Double_Typ = 7
'End Enum
    If dicAccdbDataType Is Nothing Then
        Set dicAccdbDataType = New Dictionary
    End If
    dicAccdbDataType.Add ACCDB_Data_Type.Text_typ, "TEXT"
    dicAccdbDataType.Add ACCDB_Data_Type.Char_ShortText_typ, "CHAR"
    dicAccdbDataType.Add ACCDB_Data_Type.Integer_typ, "INTEGER"
    dicAccdbDataType.Add ACCDB_Data_Type.BIT_typ, "BIT"
    dicAccdbDataType.Add ACCDB_Data_Type.COUNTER_typ, "COUNTER"
    dicAccdbDataType.Add ACCDB_Data_Type.Decimal_typ, "DECIMAL"
    dicAccdbDataType.Add ACCDB_Data_Type.Single_typ, "REAL"
    dicAccdbDataType.Add ACCDB_Data_Type.Double_Typ, "FLOAT"
    'CAT�e�[�u����Enum�����ݒ�
    Call CAT_Enum_Initialset
    'INV�e�[�u����Enum�����ݒ�
    Call INV_Enum_Initialize
End Sub
'''CAT�e�[�u����Enum�̏�����������
'''---------------------------------------------------------------------------------------------------------------------------------------------
Private Sub CAT_Enum_Initialset()
'CAT�̃w�b�_�e�[�u����`��Enum�A���ۂ̒l��clsEnum�Œ�`����
'Public Enum Enum_CAT_Header
'    T_Name = 0              'Header Table���̂��̖̂��O
'    F_Header = 1            '�eCAT�R�[�h�̃w�b�_����
'    F_DescriptionTable = 2  'Description��`�̃e�[�u����
'    F_DetailTable = 3       'Detail�̃e�[�u����
'    F_SpecialTable = 4      'Special�̃e�[�u����
'    F_InputDate = 5         '���͓���
'End Enum
    If dicCATHeaderField Is Nothing Then
        Set dicCATHeaderField = New Dictionary
    End If
    dicCATHeaderField.Add Enum_CAT_Header.T_Name_chd, CAT_CONST.T_CAT_HEADER
    dicCATHeaderField.Add Enum_CAT_Header.F_Header_chd, CAT_CONST.F_CAT_HEADER
    dicCATHeaderField.Add Enum_CAT_Header.F_DescriptionTable_chd, CAT_CONST.F_CAT_DESCRIPTIONTABLE
    dicCATHeaderField.Add Enum_CAT_Header.F_DetailTable_chd, CAT_CONST.F_CAT_DETAILTABLE
    dicCATHeaderField.Add Enum_CAT_Header.F_SpecialTable_chd, CAT_CONST.F_CAT_SPECIALTABLE
    dicCATHeaderField.Add Enum_CAT_Header.F_InputDate_chd, PublicConst.INPUT_DATE
''Description�e�[�u����Enum
'Public Enum Enum_CAT_Description
'    T_Name_0_Kishu = 0          '�C���f�b�N�X0�i�@�햼�ɒu�����K�v�jDescription�e�[�u����
'    F_Digit_Row = 1             '�t���O���Ă�Long�̐�
'    F_Descriptoin_ID = 2        'Description��ID�A���Ԃ̓}�X�^�[�e�[�u���Q��
'    F_InputDate = 3             '���͓���
'End Enum
    If dicCATDescriptionField Is Nothing Then
        Set dicCATDescriptionField = New Dictionary
    End If
    dicCATDescriptionField.Add Enum_CAT_Description.T_Name_0_Kishu_cdc, CAT_CONST.T_CAT_DESCRIPTION_0kishu
    dicCATDescriptionField.Add Enum_CAT_Description.F_Digit_Row_cdc, CAT_CONST.F_CAT_DIGIT_ROW
    dicCATDescriptionField.Add Enum_CAT_Description.F_Descriptoin_ID_cdc, CAT_CONST.F_CAT_DESCRIPTION_ID
    dicCATDescriptionField.Add Enum_CAT_Description.F_InputDate_cdc, PublicConst.INPUT_DATE
''Detail�e�[�u����Enum
'Public Enum Enum_CAT_Detail
'    T_Name_0_Kishu = 0          'Detai�e�[�u���� 0 �i�@�햼�u���j���K�v
'    F_Digit_Row = 1             '�����t���O��Long
'    F_Chr = 2                   '���ɓ��镶��
'    F_Detail_ID = 3             'Detail��ID
'    F_InputDate = 4             '���͓���
'End Enum
    If dicCATDetailField Is Nothing Then
        Set dicCATDetailField = New Dictionary
    End If
    dicCATDetailField.Add Enum_CAT_Detail.T_Name_0_Kishu_cdt, CAT_CONST.T_CAT_DETAIL_0kishu
    dicCATDetailField.Add Enum_CAT_Detail.F_Digit_Row_cdt, CAT_CONST.F_CAT_DIGIT_ROW
    dicCATDetailField.Add Enum_CAT_Detail.F_Chr_cdt, CAT_CONST.F_CAT_CHR
    dicCATDetailField.Add Enum_CAT_Detail.F_Detail_ID_cdt, CAT_CONST.F_CAT_DETAIL_ID
    dicCATDetailField.Add Enum_CAT_Detail.F_InputDate_cdt, PublicConst.INPUT_DATE
''Special�e�[�u����Enum
'Public Enum Enum_CAT_Special
'    T_Name_0_Kishu = 0          'Special�̃e�[�u�����A{0}���@�햼�u���K�v
'    F_Condition = 1             '�����t�B�[���h
'    F_Execute = 2               '���ϓ��e�t�B�[���h
'    F_InputDate = 3             '���͓���
'End Enum
    If dicCATSpecialField Is Nothing Then
        Set dicCATSpecialField = New Dictionary
    End If
    dicCATSpecialField.Add Enum_CAT_Special.T_Name_0_Kishu_csp, CAT_CONST.T_CAT_SPECIAL_0kishu
    dicCATSpecialField.Add Enum_CAT_Special.F_Condition_csp, CAT_CONST.F_CAT_CONDITION
    dicCATSpecialField.Add Enum_CAT_Special.F_Execute_csp, CAT_CONST.F_CAT_EXECUTE
    dicCATSpecialField.Add Enum_CAT_Special.F_InputDate_csp, PublicConst.INPUT_DATE
''Description�}�X�^�[�e�[�u����Enum
'Public Enum Enum_CAT_M_Description
'    T_Name = 0                  'Description�}�X�^�[�̃e�[�u����
'    F_Description_ID = 1        'Description�e�[�u���Ƌ��p�A���������e
'    F_Digit_Row = 2             'Description�e�[�u���Ƌ��p
'    F_Description_Text = 3      'Description�̖{��
'    F_InputDate = 4             '���͓���
'End Enum
    If dicCATMasterDescriptionField Is Nothing Then
        Set dicCATMasterDescriptionField = New Dictionary
    End If
    dicCATMasterDescriptionField.Add Enum_CAT_M_Description.T_Name_cmdc, CAT_CONST.T_CAT_Description_MASTER
    dicCATMasterDescriptionField.Add Enum_CAT_M_Description.F_Description_ID_cmdc, CAT_CONST.F_CAT_DESCRIPTION_ID
    dicCATMasterDescriptionField.Add Enum_CAT_M_Description.F_Digit_Row_cmdc, CAT_CONST.F_CAT_DIGIT_ROW
    dicCATMasterDescriptionField.Add Enum_CAT_M_Description.F_Description_Text_cmdc, CAT_CONST.F_CAT_DESCRIPTION_TEXT
    dicCATMasterDescriptionField.Add Enum_CAT_M_Description.F_InputDate_cmdc, PublicConst.INPUT_DATE
''Detail�}�X�^�[�e�[�u����Enum
'Public Enum Enum_CAT_M_Detail
'    T_Name = 0                  'Detail�}�X�^�[�̃e�[�u����
'    F_Detail_ID = 1             'Detail�e�[�u���Ƌ��p�A���������e
'    F_Digit_Row = 2             'Detail�e�[�u���Ƌ��p
'    F_Chr = 3                   'Detail�e�[�u���Ƌ��p
'    F_Detail_Text = 4           'Detail�̖{��
'    F_InputDate = 5             '���͓���
'End Enum
    If dicCATMasterDetailField Is Nothing Then
        Set dicCATMasterDetailField = New Dictionary
    End If
    dicCATMasterDetailField.Add Enum_CAT_M_Detail.T_Name_cmdt, CAT_CONST.T_CAT_DETAIL_MASTER
    dicCATMasterDetailField.Add Enum_CAT_M_Detail.F_Detail_ID_cmdt, CAT_CONST.F_CAT_DETAIL_ID
    dicCATMasterDetailField.Add Enum_CAT_M_Detail.F_Digit_Row_cmdt, CAT_CONST.F_CAT_DIGIT_ROW
    dicCATMasterDetailField.Add Enum_CAT_M_Detail.F_Chr_cmdt, CAT_CONST.F_CAT_CHR
    dicCATMasterDetailField.Add Enum_CAT_M_Detail.F_Detail_Text_cmdt, CAT_CONST.F_CAT_DETAIL_TEXT
    dicCATMasterDetailField.Add Enum_CAT_M_Detail.F_InputDate_cmdt, PublicConst.INPUT_DATE
''�����}�X�^�[�e�[�u����Enum
'Public Enum Enum_CAT_M_Digit
'    T_Name = 0                  '�����}�X�^�[�e�[�u���̖��O
'    F_Digit_Offset = 1          '�w�b�_�̕����̍Ō��0�Ƃ��������ʒu�̃I�t�Z�b�g�i1�����ڂ�1����n�܂�j
'    F_Digit_Row = 2             '���̃e�[�u���Ƌ��p�A�����炪�e
'End Enum
    If dicMasterDigitField Is Nothing Then
        Set dicMasterDigitField = New Dictionary
    End If
    dicMasterDigitField.Add Enum_CAT_M_Digit.T_Name_cmdg, CAT_CONST.T_CAT_DIGIT_MASTER
    dicMasterDigitField.Add Enum_CAT_M_Digit.F_Digit_Offset_cmdg, CAT_CONST.F_CAT_DIGIT_OFFSET
    dicMasterDigitField.Add Enum_CAT_M_Digit.F_Digit_Row_cmdg, CAT_CONST.F_CAT_DIGIT_ROW
''�ꎞ���p�t�B�[���hEnum
'Public Enum CAT_Tmp
'    F_Digit_Update_ctm = 0
'End Enum
    If dicCATTmpField Is Nothing Then
        Set dicCATTmpField = New Dictionary
    End If
    dicCATTmpField.Add CAT_Tmp.F_Digit_Update_ctm, CAT_CONST.F_DIGIT_UPDATE
End Sub
Private Sub INV_Enum_Initialize()
    '�݌ɏ��DB��Enum�̏��������s��
'��z�R�[�h�}�X�^�[��Enum��`
'Public Enum Enum_INV_M_Parts
'    Table_Name_IMPrt = 1
'    F_Tehai_ID_IMPrt = 2
'    F_Tehai_Code_IMPrt = 3
'    F_Manege_Section_IMPrt = 4
'    F_System_TanaNo_IMPrt = 5
'    F_Kishu_IMPrt = 6
'    F_Store_Code_IMPrt = 7
'    F_Deliver_LOT_IMPrt = 8
'    F_Fill_Lot_IMPrt = 9
'    F_Lead_Time_IMPrt = 10
'    F_Order_Amount_IMPrt = 11
'    F_Order_Remain_IMPrt = 12
'    F_Stock_Amount_IMPrt = 13
'    F_Tana_ID_IMPrt = 14
'    F_System_Name_IMPrt = 15
'    F_System_Spec_IMPrt = 16
'    F_Store_Unit_IMPrt = 17
'    F_System_Description_IMPrt = 18
'    F_Local_Description_IMPrt = 19
'    F_Manege_Section_Sub_IMPrt = 20
'    F_InputDate_IMPrt = 21
'End Enum
    If dicINVMasterParts Is Nothing Then
        Set dicINVMasterParts = New Dictionary
    End If
    dicINVMasterParts.Add Enum_INV_M_Parts.Table_Name_IMPrt, INV_CONST.T_INV_PARTS_MASTER
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Tehai_ID_IMPrt, INV_CONST.F_INV_TEHAI_ID
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Tehai_Code_IMPrt, INV_CONST.F_INV_TEHAI_TEXT
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Manege_Section_IMPrt, INV_CONST.F_INV_MANEGE_SECTON
    dicINVMasterParts.Add Enum_INV_M_Parts.F_System_TanaNo_IMPrt, INV_CONST.F_INV_SYSTEM_LOCATION_NO
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Kishu_IMPrt, INV_CONST.F_INV_KISHU
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Store_Code_IMPrt, INV_CONST.F_INV_STORE_CODE
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Deliver_Lot_IMPrt, INV_CONST.F_INV_DELIVER_LOT
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Fill_Lot_IMPrt, INV_CONST.F_INV_FILL_LOT
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Lead_Time_IMPrt, INV_CONST.F_INV_LEAD_TIME
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Order_Amount_IMPrt, INV_CONST.F_INV_ORDER_AMOUNT
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Order_Remain_IMPrt, INV_CONST.F_INV_ORDER_REMAIN
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Stock_Amount_IMPrt, INV_CONST.F_INV_STOCK_AMOUNT
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Tana_ID_IMPrt, INV_CONST.F_INV_TANA_ID
    dicINVMasterParts.Add Enum_INV_M_Parts.F_System_Name_IMPrt, INV_CONST.F_INV_SYSTEM_NAME
    dicINVMasterParts.Add Enum_INV_M_Parts.F_System_Spec_IMPrt, INV_CONST.F_INV_SYSTEM_SPEC
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Store_Unit_IMPrt, INV_CONST.F_INV_STORE_UNIT
    dicINVMasterParts.Add Enum_INV_M_Parts.F_System_Description_IMPrt, INV_CONST.F_INV_SYSTEM_DESCRIPTION
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Local_Description_IMPrt, INV_CONST.F_INV_LOCAL_DESCRIPTION
    dicINVMasterParts.Add Enum_INV_M_Parts.F_Manege_Section_Sub_IMPrt, INV_CONST.F_INV_MANEGE_SECTION_SUB
    dicINVMasterParts.Add Enum_INV_M_Parts.F_InputDate_IMPrt, PublicConst.INPUT_DATE
''�݌ɏ��V�[�g�̃t�B�[���h���i�����j
''�啔����INV_Master_Parts��Enum�Ƌ��L����
''�I�Ԃ݂̂͋��L�ł��Ȃ��̂ŁA�Ǝ��ɐ�����U��
'Public Enum Enum_Sh_Zaiko
'    F_Tehai_Code_ShZ = Enum_INV_M_Parts.F_Tehai_Code_IMPrt
'    F_Manege_Section_ShZ = Enum_INV_M_Parts.F_Manege_Section_IMPrt
'    F_System_TanaNO_ShZ = Enum_INV_M_Parts.F_System_TanaNo_IMPrt
'    F_kishu_ShZ = Enum_INV_M_Parts.F_Kishu_IMPrt
'    F_Store_Code_ShZ = Enum_INV_M_Parts.F_Store_Code_IMPrt
'    F_Deliver_Lot_ShZ = Enum_INV_M_Parts.F_Deliver_Lot_IMPrt
'    F_Fill_Lot_ShZ = Enum_INV_M_Parts.F_Fill_Lot_IMPrt
'    F_Lead_Time_ShZ = Enum_INV_M_Parts.F_Lead_Time_IMPrt
'    F_Order_Amount_ShZ = Enum_INV_M_Parts.F_Order_Amount_IMPrt
'    F_Order_Remail_ShZ = Enum_INV_M_Parts.F_Order_Remain_IMPrt
'    F_Stock_Amount_ShZ = Enum_INV_M_Parts.F_Stock_Amount_IMPrt
'    F_System_Name_ShZ = Enum_INV_M_Parts.F_System_Name_IMPrt
'    F_System_Spec_ShZ = Enum_INV_M_Parts.F_System_Spec_IMPrt
'    F_Store_Unit_ShZ = Enum_INV_M_Parts.F_Store_Unit_IMPrt
'    F_System_Description_ShZ = Enum_INV_M_Parts.F_System_Description_IMPrt
'    F_Manege_Section_Sub_ShZ = Enum_INV_M_Parts.F_Manege_Section_Sub_IMPrt
'    '�I�ԃe�L�X�g�݂̂�����œƎ��ɐݒ肷��
'    F_Tana_Text_ShZ = 101
'End Enum
    If dicSHZaikoParts Is Nothing Then
        '�݌ɏ��V�[�g��Dictionary��������
        Set dicSHZaikoParts = New Dictionary
    End If
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Deliver_Lot_ShZ, INV_CONST.F_SH_ZAIKO_DELIVER_LOT
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Fill_Lot_ShZ, INV_CONST.F_SH_ZAIKO_FILL_LOT
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_kishu_ShZ, INV_CONST.F_SH_ZAIKO_KISHU
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Lead_Time_ShZ, INV_CONST.F_SH_ZAIKO_LEAD_TIME
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Manege_Section_ShZ, INV_CONST.F_SH_ZAIKO_MANEGE_SECTON
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Manege_Section_Sub_ShZ, INV_CONST.F_SH_ZAIKO_MANEGE_SECTION_SUB
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Order_Amount_ShZ, INV_CONST.F_SH_ZAIKO_ORDER_AMOUNT
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Order_Remain_ShZ, INV_CONST.F_SH_ZAIKO_ORDER_REMAIN
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Stock_Amount_ShZ, INV_CONST.F_SH_ZAIKO_STOCK_AMOUNT
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Store_Code_ShZ, INV_CONST.F_SH_ZAIKO_STORE_CODE
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Store_Unit_ShZ, INV_CONST.F_SH_ZAIKO_STORE_UNIT
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_System_Description_ShZ, INV_CONST.F_SH_ZAIKO_SYSTEM_DESCRIPTION
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_System_Name_ShZ, INV_CONST.F_SH_ZAIKO_SYSTEM_NAME
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_System_Spec_ShZ, INV_CONST.F_SH_ZAIKO_SYSTEM_SPEC
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_System_TanaNO_ShZ, INV_CONST.F_SH_ZAIKO_SYSTEM_TANA_NO
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Tana_Text_ShZ, INV_CONST.F_SH_ZAIKO_TANA_TEXT
    dicSHZaikoParts.Add Enum_Sh_Zaiko.F_Tehai_Code_ShZ, INV_CONST.F_SH_ZAIKO_TEHAI_TEXT
End Sub
'DBExetension
Property Get DBFileExetension(DBext As DB_file_exetension) As String
    DBFileExetension = dicDBFileExetension(DBext)
End Property
'DBExetension��Dictionary
Property Get DBFileExetension_Dic() As Dictionary
    If dicDBFileExetension Is Nothing Then
        '�����o�ϐ���Nothing��������Nothing��Ԃ�
        Set DBFileExetension_Dic = Nothing
    Else
        '�����o�ϐ���Dictionary���Key���g���q�iString)�AValue��Enum�̒萔�iKey��Value�����]����j���쐬���A�Ԃ�
        Dim dicLocalResult As Dictionary
        Set dicLocalResult = New Dictionary
        Dim varKey As Variant
        For Each varKey In dicDBFileExetension
            If Not dicLocalResult.Exists(dicDBFileExetension(varKey)) Then
                '�g���q�����[�J��dic�̃L�[�ɑ��݂��Ȃ��ꍇ�̂ݒǉ�
                dicLocalResult.Add dicDBFileExetension(varKey), varKey
            End If
        Next varKey
        '�쐬����Dictionary��߂�l�Ƃ���
        Set DBFileExetension_Dic = dicLocalResult
    End If
    Exit Property
End Property
'AccdbDataType
Property Get AccdbDataType(accdbType As ACCDB_Data_Type) As String
    AccdbDataType = dicAccdbDataType(accdbType)
    Exit Property
End Property
'CATHeaderField
Property Get CATHeaderField(HeaderField As Enum_CAT_Header) As String
    CATHeaderField = dicCATHeaderField(HeaderField)
    Exit Property
End Property
'CATDescriptionField
Property Get CATDescriptionField(DescriptionField As Enum_CAT_Description) As String
    CATDescriptionField = dicCATDescriptionField(DescriptionField)
    Exit Property
End Property
'CATDetailField
Property Get CATDetailField(DetailField As Enum_CAT_Detail) As String
    CATDetailField = dicCATDetailField(DetailField)
    Exit Property
End Property
'CATSpecialField
Property Get CATSpecialField(SpecialField As Enum_CAT_Special) As String
    CATSpecialField = dicCATSpecialField(SpecialField)
    Exit Property
End Property
'MasterDescription
Property Get CATMasterDescriptionField(MasterDescriptionField As Enum_CAT_M_Description) As String
    CATMasterDescriptionField = dicCATMasterDescriptionField(MasterDescriptionField)
    Exit Property
End Property
'MasterDetail
Property Get CATMasterDetailField(MasterDetailField As Enum_CAT_M_Detail) As String
    CATMasterDetailField = dicCATMasterDetailField(MasterDetailField)
    Exit Property
End Property
'Digit
Property Get CATDigitField(DigitField As Enum_CAT_M_Digit) As String
    CATDigitField = dicMasterDigitField(DigitField)
    Exit Property
End Property
'CATTmp
Property Get CATTempField(TmpField As CAT_Tmp) As String
    CATTempField = dicCATTmpField(TmpField)
    Exit Property
End Property
'-----------------------------------------------------------------------------------------------------------------------------
'Sh_Zaiko
Property Get shZaikoField(ZaikoField As Enum_Sh_Zaiko) As String
    shZaikoField = dicSHZaikoParts(ZaikoField)
    Exit Property
End Property
'-----------------------------------------------------------------------------------------------------------------------------
'INV_DB
'INVMasterParts
Property Get INVMasterParts(MasterPartsField As Enum_INV_M_Parts) As String
    INVMasterParts = dicINVMasterParts(MasterPartsField)
    Exit Property
End Property
'-----------------------------------------------------------------------------------------------------------------------------
'�v���V�[�W���[
'''Author Daisuke Oota 2021_01_06
'''�݌ɏ��V�[�g��T_INV_Master_Parts�̋��ʃt�B�[���h��String�̔z��ɂ��ĕԂ�
'''�߂�l StringArray(n,1),n�͋��ʃt�B�[���h���A2�����ڂ́A0��DB�t�B�[���h�A1���V�[�g�̃t�B�[���h��
'''�V�[�gdi�ɂ��������l�i��z�R�[�h�Ƃ��j��2�����ڂ͏����l�ɂȂ�̂ŁA�󂯎�葤�Ŕ��f����
'''ex)(0,0) F_INV_Tehai_Code (0,1) ��z�R�[�h
Public Function GetZaikoFieldNameArrayShandDB() As String()
    If dicINVMasterParts Is Nothing Or dicSHZaikoParts Is Nothing Then
        'DB����dic���V�[�g����dic��Nothing������
        '���������ɔ�����
        DebugMsgWithTime "GetZaikoFieldArray: member dictionary is nothing"
        Exit Function
    End If
    Dim arrZaikoField() As String
    'String�z����V�[�gdic�̗v�f���ŏ�����
    ReDim arrZaikoField(dicSHZaikoParts.Count - 1, 1)
    '�V�[�gdic�Ń��[�v����
    Dim intArrRowCounter As Integer
    intArrRowCounter = 0
    Dim varshKey As Variant
    For Each varshKey In dicSHZaikoParts
        If dicINVMasterParts.Exists(varshKey) Then
            '�V�[�gdic�Ƌ��ʂ�Key��DBdic�ɂ����݂��鎞
            '�V�[�gdic��DBdic���ꂼ��̒l��string�z��ɓ���Ă��
            'DB�t�B�[���h
            arrZaikoField(intArrRowCounter, 0) = CStr(dicINVMasterParts(varshKey))
            '�V�[�g�t�B�[���h
            arrZaikoField(intArrRowCounter, 1) = CStr(dicSHZaikoParts(varshKey))
        Else
            '�V�[�gdic�ɂ���key�����݂��Ȃ��ꍇ
            '2�����ڂ�1�ɃV�[�gdic��Value�݂̂����Ă��A2�����ڂ�0�͏����l
            '�V�[�g�t�B�[���h�̂�
            arrZaikoField(intArrRowCounter, 1) = CStr(dicSHZaikoParts(varshKey))
        End If
        'StringArray�s�J�E���^�[���C���N�������g
        intArrRowCounter = intArrRowCounter + 1
    Next varshKey
    '���ʂ�Ԃ�
    GetZaikoFieldNameArrayShandDB = arrZaikoField
    Exit Function
End Function