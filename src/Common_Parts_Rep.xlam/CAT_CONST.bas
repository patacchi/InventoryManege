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
Public Enum CAT_Header_Field
    T_Name = 0              'Header Table���̂��̖̂��O
    F_Header = 1            '�eCAT�R�[�h�̃w�b�_����
    F_DescriptionTable = 2  'Description��`�̃e�[�u����
    F_DetailTable = 3       'Detail�̃e�[�u����
    F_SpecialTable = 4      'Special�̃e�[�u����
    F_InputDate = 5         '���͓���
End Enum
'�i�e�@��j_Description
'�e���̊T�v�i��ށj���i�[���� �e�[�u������ T_CAT_�i�e�@�햼�j_Description �Ƃ���
'�������̂͊O���L�[�Ƃ��Đݒ肵�A�e�e�[�u����T_CAT_M_Description�Ƃ���
'���@��ŋ��L����O��Ő݌v����
Public Const T_CAT_DESCRIPTION_0kishu As String = "T_CAT_{0}_Description"   'Detail�e�[�u���� {0}�Ɋe�@��𖄂ߍ���
Public Const F_CAT_DIGIT_ROW As String = "F_CAT_Digit_Row"                  '�����̃r�b�g�̃t���O�𗧂Ă�Long�̐��An���ڂ�2^(n-1) 3���ڂȂ�4�A�e�e�[�u���ɂ͂��̒l���Z�b�g����
Public Const F_CAT_DESCRIPTION_ID As String = "F_CAT_Description_ID"        'Description��ID������
'Description�e�[�u����Enum
Public Enum CAT_Description_Field
    T_Name_0_Kishu = 0          '�C���f�b�N�X0�i�@�햼�ɒu�����K�v�jDescription�e�[�u����
    F_Digit_Row = 1             '�t���O���Ă�Long�̐�
    F_Descriptoin_ID = 2        'Description��ID�A���Ԃ̓}�X�^�[�e�[�u���Q��
    F_InputDate = 3             '���͓���
End Enum
'�i�e�@��j_Detail
'CAT�R�[�h�̊e���ʒu�ɑ΂���������i�[����i���C���e�[�u���j
'�e�[�u������ T_CAT_�i�e�@�햼�j_Detail�Ƃ��� ��̃e�[�u���ɕ����@����i�[����\��������
Public Const T_CAT_DETAIL_0kishu As String = "T_CAT_{0}_Detail"             '{0}�ɋ@�햼�𖄂ߍ���
Public Const F_CAT_CHR As String = "F_CAT_Chr"                              '���̌��ɓ��镶����
Public Const F_CAT_DETAIL_ID As String = "F_CAT_Detail_ID"                  'Detail��ID������
'Detail�e�[�u����Enum
Public Enum CAT_Detail_Field
    T_Name_0_Kishu = 0          'Detai�e�[�u���� 0 �i�@�햼�u���j���K�v
    F_Digit_Row = 1             '�����t���O��Long
    F_Chr = 2                   '���ɓ��镶��
    F_Detail_ID = 3             'Detail��ID
    F_InputDate = 4             '���͓���
End Enum
'�i�e�@��j_Special
'����ȑg�ݍ��킹�ŕ\�����ς����̂��W�߂��e�[�u��
'�����A���ʁi���ώ��s�j�ǂ����JSON�Ŋi�[����
Public Const T_CAT_SPECIAL_0kishu As String = "T_CAT_{0}_Special"           '{0}�ɋ@�햼������
Public Const F_CAT_CONDITION As String = "F_CAT_Condition"                  '������JSON�Ŋi�[
Public Const F_CAT_EXECUTE As String = "F_CAT_Excute"                       '���ς�����e��JSON�Ŋi�[
'Special�e�[�u����Enum
Public Enum CAT_Special_Field
    T_Name_0_Kishu = 0          'Special�̃e�[�u�����A{0}���@�햼�u���K�v
    F_Condition = 1             '�����t�B�[���h
    F_Execute = 2               '���ϓ��e�t�B�[���h
    F_InputDate = 3             '���͓���
End Enum
'Description�}�X�^�[�e�[�u��
'���ۂ̊T�v�͂������ɓ���B�e�e�[�u��
Public Const T_CAT_Description_MASTER As String = "T_CAT_M_Description"     'Description�̃}�X�^�[
Public Const F_CAT_DESCRIPTION_TEXT As String = "F_CAT_Description"         '���ۂ̊T�v�̓��e������t�B�[���h
'Description�}�X�^�[�e�[�u����Enum
Public Enum CAT_M_Description_Field
    T_Name = 0                  'Description�}�X�^�[�̃e�[�u����
    F_Description_ID = 1        'Description�e�[�u���Ƌ��p�A���������e
    F_Digit_Row = 2             'Description�e�[�u���Ƌ��p
    F_Description_Text = 3      'Description�̖{��
    F_InputDate = 4             '���͓���
End Enum
'Detail�}�X�^�[�e�[�u��
Public Const T_CAT_DETAIL_MASTER As String = "T_CAT_M_Detail"               'Detail�}�X�^�[�̃e�[�u����
Public Const F_CAT_DETAIL_TEXT As String = "F_CAT_Detail"                   '���ۂ̎d�l�ڍׂ�����t�B�[���h
'Detail�}�X�^�[�e�[�u����Enum
Public Enum CAT_M_Detail_Field
    T_Name = 0                  'Detail�}�X�^�[�̃e�[�u����
    F_Detail_ID = 1             'Detail�e�[�u���Ƌ��p�A���������e
    F_Digit_Row = 2             'Detail�e�[�u���Ƌ��p
    F_Chr = 3                   'Detail�e�[�u���Ƌ��p
    F_Detail_Text = 4           'Detail�̖{��
    F_InputDate = 5             '���͓���
End Enum
'�����}�X�^�[�e�[�u��
Public Const T_CAT_DIGIT_MASTER As String = "T_CAT_M_Digit"                 '������Long�̐��̑Ή��e�[�u��
Public Const F_CAT_DIGIT_OFFSET As String = "F_CAT_DigitOffset"             '�w�b�_�̕����̍Ō��0�Ƃ��������ʒu�̃I�t�Z�b�g�A����JSON(String�z��j�Ŋi�[���邩���H
'�����}�X�^�[�e�[�u����Enum
Public Enum CAT_M_Digit_Field
    DigitT_Name = 0                  '�����}�X�^�[�e�[�u���̖��O
    F_Digit_Offset = 1          '�w�b�_�̕����̍Ō��0�Ƃ��������ʒu�̃I�t�Z�b�g�i1�����ڂ�1����n�܂�j
    F_DigitM_Row = 2             '���̃e�[�u���Ƌ��p�A�����炪�e
End Enum
'F_CAT_DIGIT_ROW
'�����t�B�[���h�ϊ��p�i�o�ߑ[�u�j�A�S���I�������폜����
Public Const F_DIGIT_UPDATE As String = "F_Digit_Update"                    '�����`���ϊ��������������ǂ����A����������True���Z�b�g����
'--------------------------------------------------------------------------------------------------------------------------------------------------------------
'SQL��`
'�����@��p�ɋ@�햼�ꗗ�����o��SQL
Public Const SQL_KISHU_LIST As String = "SELECT " & F_CAT_HEADER & "," & F_CAT_DESCRIPTIONTABLE & "," & F_CAT_DETAILTABLE & "," & F_CAT_SPECIALTABLE & vbCrLf _
                                        & " FROM " & T_CAT_HEADER
'�t�B�[���h�ǉ�SQL
Public Const SQL_APPEND_FIELD_0Tableneme_1fieldname_2DataType As String = "ALTER TABLE {0} ADD COLUMN {1} {2}"      '{0}��TableName��{1}�Ƀt�B�[���h���� {2}�Ƀt�B�[���h�^�C�v������
'�t�B�[���h�f�[�^�^Enum
Public Enum ACCDB_Data_Type
    [Text] = 1
    [INTEGER] = 2
    [BIT] = 3
    [Boolean] = 3
    [COUNTER] = 4
    [AUTOINCREMENT] = 4
    [Decimal] = 5
End Enum
'�t�B�[���h�폜SQL
Public Const SQL_DELETE_FIELD_0Tablename_1Fieldname As String = "ALTER TABLE {0} DROP COLUMN {1}"                   '{0}��TableName���A{1}�Ƀt�B�[���h��������