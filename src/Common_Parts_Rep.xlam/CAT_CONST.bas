Attribute VB_Name = "CAT_CONST"
Option Explicit
'''CAT�e�[�u���Ɋւ���萔��u���Ă���
'Global
Public Const CAT_DB_FILENAME As String = "CAT_Find.accdb"                   'CAT�R�[�h��DB�t�@�C����
'�e�e�[�u���ɂ�Default�Ƃ���InputDate������
Public Const INPUT_DATE As String = "InputDate"
'Header
Public Const T_CAT_HEADER As String = "T_CAT_Header"                        'CAT�R�[�h�̃w�b�_�����l�ߍ��񂾃e�[�u���i�N�_�j
Public Const F_CAT_HEADER As String = "F_CAT_Header"                        'CAT�w�b�_�̃t�B�[���h���A���ꂪ�ʏ�@�햼�ɂȂ�
Public Const F_CAT_DESCRIPTIONTABLE As String = "F_CAT_DescriptionTable"    'Description�e�[�u���̃t�B�[���h��
Public Const F_CAT_DETAILTABLE As String = "F_CAT_DetailTable"              '�ڍׁi�d�l�j�e�[�u�����̃t�B�[���h��
Public Const F_CAT_SPECIALTABLE As String = "F_CAT_SpecialTable"            '����������L�ڂ����e�[�u�����̃t�B�[���h��
'CAT�̃w�b�_�e�[�u����`��Enum�A���ۂ̒l��clsEnum�Œ�`����
'�����o�[���d���h�~����Ɠ���Enum���ʖ������Ȃ��ƃR���p�C���G���[�ɂȂ邽�߁A�����o�[���͏d�����Ȃ��悤�ɂ���
'�d������� ���O���K�؂ł͂���܂��� �̃G���[����������
'�d���h�~�̂��߁A�T�t�B�b�N�X�Ƃ��Č����A_??? ��t������
'�}�X�^�[�e�[�u���̃T�t�B�b�N�X��_?m?? �Ƃ���
Public Enum Enum_CAT_Header
    T_Name_chd = 0              'Header Table���̂��̖̂��O
    F_Header_chd = 1            '�eCAT�R�[�h�̃w�b�_����
    F_DescriptionTable_chd = 2  'Description��`�̃e�[�u����
    F_DetailTable_chd = 3       'Detail�̃e�[�u����
    F_SpecialTable_chd = 4      'Special�̃e�[�u����
    F_InputDate_chd = 5         '���͓���
End Enum
'�i�e�@��j_Description
'�e���̊T�v�i��ށj���i�[���� �e�[�u������ T_CAT_�i�e�@�햼�j_Description �Ƃ���
'�������̂͊O���L�[�Ƃ��Đݒ肵�A�e�e�[�u����T_CAT_M_Description�Ƃ���
'���@��ŋ��L����O��Ő݌v����
Public Const T_CAT_DESCRIPTION_0kishu As String = "T_CAT_{0}_Description"   'Detail�e�[�u���� {0}�Ɋe�@��𖄂ߍ���
Public Const F_CAT_DIGIT_ROW As String = "F_CAT_Digit_Row"                  '�����̃r�b�g�̃t���O�𗧂Ă�Long�̐��An���ڂ�2^(n-1) 3���ڂȂ�4�A�e�e�[�u���ɂ͂��̒l���Z�b�g����
Public Const F_CAT_DESCRIPTION_ID As String = "F_CAT_Description_ID"        'Description��ID������
'Description�e�[�u����Enum
Public Enum Enum_CAT_Description
    T_Name_0_Kishu_cdc = 0          '�C���f�b�N�X0�i�@�햼�ɒu�����K�v�jDescription�e�[�u����
    F_Digit_Row_cdc = 1             '�t���O���Ă�Long�̐�
    F_Descriptoin_ID_cdc = 2        'Description��ID�A���Ԃ̓}�X�^�[�e�[�u���Q��
    F_InputDate_cdc = 3             '���͓���
End Enum
'�i�e�@��j_Detail
'CAT�R�[�h�̊e���ʒu�ɑ΂���������i�[����i���C���e�[�u���j
'�e�[�u������ T_CAT_�i�e�@�햼�j_Detail�Ƃ��� ��̃e�[�u���ɕ����@����i�[����\��������
Public Const T_CAT_DETAIL_0kishu As String = "T_CAT_{0}_Detail"             '{0}�ɋ@�햼�𖄂ߍ���
Public Const F_CAT_CHR As String = "F_CAT_Chr"                              '���̌��ɓ��镶����
Public Const F_CAT_DETAIL_ID As String = "F_CAT_Detail_ID"                  'Detail��ID������
'Detail�e�[�u����Enum
Public Enum Enum_CAT_Detail
    T_Name_0_Kishu_cdt = 0          'Detai�e�[�u���� 0 �i�@�햼�u���j���K�v
    F_Digit_Row_cdt = 1             '�����t���O��Long
    F_Chr_cdt = 2                   '���ɓ��镶��
    F_Detail_ID_cdt = 3             'Detail��ID
    F_InputDate_cdt = 4             '���͓���
End Enum
'�i�e�@��j_Special
'����ȑg�ݍ��킹�ŕ\�����ς����̂��W�߂��e�[�u��
'�����A���ʁi���ώ��s�j�ǂ����JSON�Ŋi�[����
Public Const T_CAT_SPECIAL_0kishu As String = "T_CAT_{0}_Special"           '{0}�ɋ@�햼������
Public Const F_CAT_CONDITION As String = "F_CAT_Condition"                  '������JSON�Ŋi�[
Public Const F_CAT_EXECUTE As String = "F_CAT_Excute"                       '���ς�����e��JSON�Ŋi�[
'Special�e�[�u����Enum
Public Enum Enum_CAT_Special
    T_Name_0_Kishu_csp = 0          'Special�̃e�[�u�����A{0}���@�햼�u���K�v
    F_Condition_csp = 1             '�����t�B�[���h
    F_Execute_csp = 2               '���ϓ��e�t�B�[���h
    F_InputDate_csp = 3             '���͓���
End Enum
'Description�}�X�^�[�e�[�u��
'���ۂ̊T�v�͂������ɓ���B�e�e�[�u��
Public Const T_CAT_Description_MASTER As String = "T_CAT_M_Description"     'Description�̃}�X�^�[
Public Const F_CAT_DESCRIPTION_TEXT As String = "F_CAT_Description"         '���ۂ̊T�v�̓��e������t�B�[���h
'Description�}�X�^�[�e�[�u����Enum
Public Enum Enum_CAT_M_Description
    T_Name_cmdc = 0                  'Description�}�X�^�[�̃e�[�u����
    F_Description_ID_cmdc = 1        'Description�e�[�u���Ƌ��p�A���������e
    F_Digit_Row_cmdc = 2             'Description�e�[�u���Ƌ��p
    F_Description_Text_cmdc = 3      'Description�̖{��
    F_InputDate_cmdc = 4             '���͓���
End Enum
'Detail�}�X�^�[�e�[�u��
Public Const T_CAT_DETAIL_MASTER As String = "T_CAT_M_Detail"               'Detail�}�X�^�[�̃e�[�u����
Public Const F_CAT_DETAIL_TEXT As String = "F_CAT_Detail"                   '���ۂ̎d�l�ڍׂ�����t�B�[���h
'Detail�}�X�^�[�e�[�u����Enum
Public Enum Enum_CAT_M_Detail
    T_Name_cmdt = 0                  'Detail�}�X�^�[�̃e�[�u����
    F_Detail_ID_cmdt = 1             'Detail�e�[�u���Ƌ��p�A���������e
    F_Digit_Row_cmdt = 2             'Detail�e�[�u���Ƌ��p
    F_Chr_cmdt = 3                   'Detail�e�[�u���Ƌ��p
    F_Detail_Text_cmdt = 4           'Detail�̖{��
    F_InputDate_cmdt = 5             '���͓���
End Enum
'�����}�X�^�[�e�[�u��
Public Const T_CAT_DIGIT_MASTER As String = "T_M_Digit"                 '������Long�̐��̑Ή��e�[�u��
Public Const F_CAT_DIGIT_OFFSET As String = "F_CAT_DigitOffset"             '�w�b�_�̕����̍Ō��0�Ƃ��������ʒu�̃I�t�Z�b�g�A����JSON(String�z��j�Ŋi�[���邩���H
'�����}�X�^�[�e�[�u����Enum
Public Enum Enum_CAT_M_Digit
    T_Name_cmdg = 0                 '�����}�X�^�[�e�[�u���̖��O
    F_Digit_Offset_cmdg = 1         '�w�b�_�̕����̍Ō��0�Ƃ��������ʒu�̃I�t�Z�b�g�i1�����ڂ�1����n�܂�j
    F_Digit_Row_cmdg = 2            '���̃e�[�u���Ƌ��p�A�����炪�e
End Enum
'�����t�B�[���h�ϊ��p�i�o�ߑ[�u�j�A�S���I�������폜����
Public Const F_DIGIT_UPDATE As String = "F_Digit_Update"                    '�����`���ϊ��������������ǂ����A����������True���Z�b�g����
'�ꎞ���p�t�B�[���hEnum
Public Enum CAT_Tmp
    F_Digit_Update_ctm = 0
End Enum
'--------------------------------------------------------------------------------------------------------------------------------------------------------------
'SQL��`
'�����@��p�ɋ@�햼�ꗗ�����o��SQL
Public Const SQL_KISHU_LIST As String = "SELECT " & F_CAT_HEADER & "," & F_CAT_DESCRIPTIONTABLE & "," & F_CAT_DETAILTABLE & "," & F_CAT_SPECIALTABLE & vbCrLf _
                                        & " FROM " & T_CAT_HEADER
'�t�B�[���h�ǉ�SQL
Public Const SQL_APPEND_FIELD_0Tableneme_1fieldname_2DataType As String = "ALTER TABLE {0} ADD COLUMN {1} {2}"      '{0}��TableName��{1}�Ƀt�B�[���h���� {2}�Ƀt�B�[���h�^�C�v������
'�t�B�[���h�f�[�^�^Enum
Public Enum ACCDB_Data_Type
    'LongText
    '�f�[�^�T�C�Y���w��(255�ȉ�)�����ShortText�ɂȂ�
    '�f�[�^�T�C�Y���w�肵�Ȃ�LongText���ƐF�X����������̂Ŕ񐄏�
    Text_typ = 1
    'ShortText
    '���܂�g��Ȃ��ق�����������
    Char_ShortText_typ = 2
    Integer_typ = 3
    BIT_typ = 4
    Boolean_typ = 4
    COUNTER_typ = 5
    AUTOINCREMENT_typ = 5
    Decimal_typ = 6
    Single_typ = 7
    Double_Typ = 8
End Enum
'�t�B�[���h�폜SQL
Public Const SQL_DELETE_FIELD_0Tablename_1Fieldname As String = "ALTER TABLE {0} DROP COLUMN {1}"                   '{0}��TableName���A{1}�Ƀt�B�[���h��������
'�t�B�[���h�f�[�^�^�ύXSQL
Public Const SQL_CHANGE_DATATYPE_0Tablename_1Fieldname_2DataType As String = "ALTER TABLE {0} ALTER COLUMN {1} {2}" '0��Tablename�A1��FieldName�A2��DataType������
'InputDate .fff�C��SQL UPDATE �Ńe�[�u���� INNER JOIN ���g�p
'{0}��TableName������
Public Const SQL_FIX_INPUTDATE_0_TableName As String = "UPDATE " & vbCrLf & _
    "{0} AS Torigin" & vbCrLf & _
    "   INNER JOIN" & vbCrLf & _
    "       (" & vbCrLf & _
    "       SELECT InputDate," & vbCrLf & _
    "       REPLACE(InputDate, ""fff"", ""000"") As InputDate_Replace" & vbCrLf & _
    "       FROM {0}" & vbCrLf & _
    "       ) AS T1" & vbCrLf & _
    "   ON Torigin.InputDate = T1.InputDate" & vbCrLf & _
    "SET Torigin.InputDate = T1.InputDate_Replace" & vbCrLf & _
    "WHERE Torigin.InputDate <> T1.InputDate_Replace"
'DigitOffset �� DigitRow
'{0}��TableName�A{1}��DigitOffset {2}��DigitRow {3} ��DigitUpdate������
Public Const SQL_FIX_DIGITOFFSET_0_TableName_1_DigitOffset_2_DigitRow_3_DigitUpdate As String = "UPDATE" & vbCrLf & _
"   {0} As Torigin" & vbCrLf & _
"   INNER JOIN T_M_Digit as T1" & vbCrLf & _
"   ON Torigin.{1} = T1.{1}" & vbCrLf & _
"SET" & vbCrLf & _
"   Torigin.{2} = T1.{2} ," & vbCrLf & _
"   Torigin.{3} = True" & vbCrLf & _
"WHERE" & vbCrLf & _
"   Torigin.{2} <> T1.{2}" & vbCrLf & _
"   OR Torigin.{2} IS NULL"