Attribute VB_Name = "INV_CONST"
''''�݌ɊǗ��֌W�̒萔���`����
Option Explicit
'�݌ɏ��DB�Ɋւ���萔
Public Const INV_DB_FILENAME As String = "INV_Manege.accdb"                     '�݌ɏ���DB�t�@�C����
Public Const T_INV_TEMP As String = "T_INV_Temp"                                'INVDB�̈ꎞ�e�[�u����
Public Const T_INV_SELECT_TEMP As String = "T_INV_Select_Temp"                  'Select�������ʂ��i�[����e�[�u�����A��U�e�[�u���Ɋi�[���Ȃ���
                                                                                '�X�V�\�ȃN�G�����E�E�E�Ƃ������邽��
Public Const INV_DOC_LABEL_MAILMERGE As String = "INV_Label_Mailmerge_Local.docm"           '���x���������݈���̃t�B�[���h�ݒ�ς�WordDocument��
Public Const INV_DOC_LABEL_PLANE As String = "INV_Label_MailmergePlain_Local.docm"          '���x���������݂̏o�͗p��Document��
Public Const INV_DOC_LABEL_GENPIN_SMALL As String = "INV_Genpin_Small_Local.docx"           '���i�[(��)�̍������݈���e���v���[�g
Public Const INV_DOC_LABEL_SPECSHEET_Small As String = "INV_SpecSheet_Small_Local.docx"     '�t���L��(���x���Ɠ���+�I�[�_�[No) �� �e���v���[�g
'���i�i��z�R�[�h�j�}�X�^�[�e�[�u���̒萔
Public Const T_INV_M_Parts As String = "T_INV_M_Parts"                          '��z�R�[�h�}�X�^�[�̃e�[�u����
Public Const F_INV_TEHAI_ID As String = "F_INV_Tehai_ID"                        '��z�R�[�h��ID�A�e�e�[�u���ɂ͂��̒l��ݒ肷��
Public Const F_INV_TEHAI_TEXT As String = "F_INV_Tehai_Code"                    '��z�R�[�h
Public Const F_INV_MANEGE_SECTON As String = "F_INV_Manege_Section"             '�Ǘ���
Public Const F_INV_SYSTEM_LOCATION_NO As String = "F_INV_System_Location_No"    '�V�X�e�����̒I�ԍ�
Public Const F_INV_KISHU As String = "F_INV_Kishu"                              '�@�햼
Public Const F_INV_STORE_CODE As String = "F_INV_Store_Code"                    '�����L��
Public Const F_INV_DELIVER_LOT As String = "F_INV_Deliver_Lot"                  '�����o�����b�g
Public Const F_INV_FILL_LOT As String = "F_INV_Fill_Lot"                        '��[���b�g
Public Const F_INV_LEAD_TIME As String = "F_INV_Lead_Time"                      '���[�h�^�C��
Public Const F_INV_ORDER_AMOUNT As String = "F_INV_Order_Amount"                '������
Public Const F_INV_ORDER_REMAIN As String = "F_INV_Order_Remain"                '�����c��
Public Const F_INV_STOCK_AMOUNT As String = "F_INV_Stock_Amount"                '�݌ɐ�
Public Const F_INV_TANA_ID As String = "F_INV_Tana_ID"                          '�I�ԃ}�X�^�[��ID�A���ۂ̓��e�͒I�}�X�^�[�e�[�u���Œ�`����
Public Const F_INV_SYSTEM_NAME As String = "F_INV_System_Name"                  '�V�X�e�����̕i���ACASE�Ƃ�
Public Const F_INV_SYSTEM_SPEC As String = "F_INV_System_Spec"                  '�V�X�e�����̌^�i�AIMONO�Ƃ�
Public Const F_INV_STORE_UNIT As String = "F_INV_Sotre_Unit"                    '�����P�ʁ@P�Ƃ�SET�Ƃ���
Public Const F_INV_SYSTEM_DESCRIPTION As String = "F_INV_System_Description"    '�V�X�e�����̎��R�L�q��
Public Const F_INV_LOCAL_DESCRIPTION As String = "F_INV_Local_Description"      '4701�Ǝ��̏ڍׂ��L�q�������ꍇ�Ɏg�p����
Public Const F_INV_MANEGE_SECTION_SUB As String = "F_INV_Manege_Section_Sub"    '�V�X�e�����̊Ǘ��ۃT�u
Public Const F_INV_LABEL_NAME_1 As String = "F_INV_Label_Name_1"                'BIN�J�[�h���x���̕i��1�s�� CASE
Public Const F_INV_LABEL_NAME_2 As String = "F_INV_Label_Name_2"                'BIN�J�[�h���x���̕i��2�s�ځA�s���̏��Ȃ����̂̕i���͂��̃t�B�[���h�̒l���g�� LF470�R�A
Public Const F_INV_LABEL_REMARK_1 As String = "F_INV_Label_Remark_1"            'BIN�J�[�h���x���̔��l1�s�� �K�т₷���̂Œ���
Public Const F_INV_LABEL_REMARK_2 As String = "F_INV_Label_Remark_2"            'BIN�J�[�h���x���̔��l2�s�� �ۊǂ̍ۊ����܂��p�E�`�t���܂ɓ��鎖
'��z�R�[�h�}�X�^�[��Enum��`
Public Enum Enum_INV_M_Parts
    Table_Name_IMPrt = 1
    F_Tehai_ID_IMPrt = 2
    F_Tehai_Code_IMPrt = 3
    F_Manege_Section_IMPrt = 4
    F_System_TanaNo_IMPrt = 5
    F_Kishu_IMPrt = 6
    F_Store_Code_IMPrt = 7
    F_Deliver_Lot_IMPrt = 8
    F_Fill_Lot_IMPrt = 9
    F_Lead_Time_IMPrt = 10
    F_Order_Amount_IMPrt = 11
    F_Order_Remain_IMPrt = 12
    F_Stock_Amount_IMPrt = 13
    F_Tana_ID_IMPrt = 14
    F_System_Name_IMPrt = 15
    F_System_Spec_IMPrt = 16
    F_Store_Unit_IMPrt = 17
    F_System_Description_IMPrt = 18
    F_Local_Description_IMPrt = 19
    F_Manege_Section_Sub_IMPrt = 20
    F_InputDate_IMPrt = 21
    'BIN�J�[�h�A�\���֌W�Ń��[�J������
    F_Label_Name_1_IMPrt = 22
    F_Label_Name_2_IMPrt = 23
    F_Label_Remark_1_IMPrt = 24
    F_Label_Remark_2_IMPrt = 25
End Enum
'�݌ɏ��V�[�g�Ɋւ���萔
'Excel�t�@�C�����͓��t���V���A���l�Ƃ����������t������̂ŁA����ϓ�����
Public Const INV_SH_ZAIKO_NAME As String = "�݌ɏ��"                       '�݌Ɍ����Ń_�E�����[�h�ł���Excel�t�@�C���̍݌ɏ��V�[�g��
Public Const F_SH_ZAIKO_TEHAI_TEXT As String = "��z�R�[�h"                 '��z�R�[�h
Public Const F_SH_ZAIKO_MANEGE_SECTON As String = "�Ǘ��ۋL��"              '�Ǘ���
Public Const F_SH_ZAIKO_SYSTEM_TANA_NO As String = "�I��"                   '�V�X�e�����̒I�ԍ�
Public Const F_SH_ZAIKO_KISHU As String = "��z�@��"                        '�@�햼
Public Const F_SH_ZAIKO_STORE_CODE As String = "�����L��"                   '�����L��
Public Const F_SH_ZAIKO_DELIVER_LOT As String = "���o���b�g"                '�����o�����b�g
Public Const F_SH_ZAIKO_FILL_LOT As String = "��[�_����"                   '��[���b�g
Public Const F_SH_ZAIKO_LEAD_TIME As String = "���[�h�^�C��"                '���[�h�^�C��
Public Const F_SH_ZAIKO_ORDER_AMOUNT As String = "������"                   '������
Public Const F_SH_ZAIKO_ORDER_REMAIN As String = "�����c"                   '�����c��
Public Const F_SH_ZAIKO_STOCK_AMOUNT As String = "�݌ɐ���"                 '�݌ɐ�
Public Const F_SH_ZAIKO_SYSTEM_NAME As String = "�i���L��"                  '�V�X�e�����̕i���ACASE�Ƃ�
Public Const F_SH_ZAIKO_SYSTEM_SPEC As String = "�^�i�L��"                  '�V�X�e�����̌^�i�AIMONO�Ƃ�
Public Const F_SH_ZAIKO_STORE_UNIT As String = "�P��"                       '�����P�ʁ@P�Ƃ�SET�Ƃ���
Public Const F_SH_ZAIKO_SYSTEM_DESCRIPTION As String = "�݌Ɏ��R�L�q"       '�V�X�e�����̎��R�L�q��
Public Const F_SH_ZAIKO_MANEGE_SECTION_SUB As String = "�Ǘ��ۃT�u"         '�V�X�e�����̊Ǘ��ۃT�u
Public Const F_SH_ZAIKO_TANA_TEXT As String = "���P�[�V����"                '�I�ԍ����O�ADB�ɂ͒I�}�X�^�[�e�[�u���������������ID���Z�b�g����
'�݌ɏ��V�[�g��Enum
'�啔����INV_Master_Parts��Enum�Ƌ��L����
'�I�Ԃ݂̂͋��L�ł��Ȃ��̂ŁA�Ǝ��ɐ�����U��
Public Enum Enum_Sh_Zaiko
    F_Tehai_Code_ShZ = Enum_INV_M_Parts.F_Tehai_Code_IMPrt
    F_Manege_Section_ShZ = Enum_INV_M_Parts.F_Manege_Section_IMPrt
    F_System_TanaNO_ShZ = Enum_INV_M_Parts.F_System_TanaNo_IMPrt
    F_kishu_ShZ = Enum_INV_M_Parts.F_Kishu_IMPrt
    F_Store_Code_ShZ = Enum_INV_M_Parts.F_Store_Code_IMPrt
    F_Deliver_Lot_ShZ = Enum_INV_M_Parts.F_Deliver_Lot_IMPrt
    F_Fill_Lot_ShZ = Enum_INV_M_Parts.F_Fill_Lot_IMPrt
    F_Lead_Time_ShZ = Enum_INV_M_Parts.F_Lead_Time_IMPrt
    F_Order_Amount_ShZ = Enum_INV_M_Parts.F_Order_Amount_IMPrt
    F_Order_Remain_ShZ = Enum_INV_M_Parts.F_Order_Remain_IMPrt
    F_Stock_Amount_ShZ = Enum_INV_M_Parts.F_Stock_Amount_IMPrt
    F_System_Name_ShZ = Enum_INV_M_Parts.F_System_Name_IMPrt
    F_System_Spec_ShZ = Enum_INV_M_Parts.F_System_Spec_IMPrt
    F_Store_Unit_ShZ = Enum_INV_M_Parts.F_Store_Unit_IMPrt
    F_System_Description_ShZ = Enum_INV_M_Parts.F_System_Description_IMPrt
    F_Manege_Section_Sub_ShZ = Enum_INV_M_Parts.F_Manege_Section_Sub_IMPrt
    '�I�ԃe�L�X�g�݂̂�����œƎ��ɐݒ肷��100�ԑ�`
    F_Tana_Text_ShZ = 101
End Enum
'�I�ԃ}�X�^�[
Public Const T_INV_M_Tana As String = "T_INV_M_Tana"                            '�I�ԃ}�X�^�[�̃e�[�u����
'�t�B�[���h���萔
Public Const F_INV_TANA_LOCAL_TEXT As String = "F_INV_Tana_Local_Text"              '�\���p�Ȃǃ��[�J���Ŏg�p����I�Ԗ� K05G B01
Public Const F_INV_TANA_SYSTEM_TEXT As String = "F_INV_Tana_System_Text"            '�V�X�e�����̒I��
Public Const F_INV_TANA_TIET_DELIVARY As String = "F_INV_TIET_Delivery"                  'TIET�o�ɂ̒I���ǂ���
'T_M_Tana�t�B�[���h��`Enum
Public Enum Enum_INV_M_Tana
    '���ʃt�B�[���h
    F_INV_TANA_ID_IMT = Enum_INV_M_Parts.F_Tana_ID_IMPrt
    'Tana�e�[�u���݂̂ɂ���̂�100�ԑ�ɂ���
    F_INV_Tana_Local_Text_IMT = 102
    F_INV_Tana_System_Text_IMT = 103
    F_INV_TIET_Delivary_IMT = 104
    F_InputDate_IMT = 105
End Enum
'�݌ɏ��V�[�g��Update�|����ۂ�Trim�K�v�ȃt�B�[���h�����`
'_ntrm need trim
Public Enum Enum_SH_Zaiko_Need_Trim
    F_Manege_Section_ntrm = Enum_Sh_Zaiko.F_Manege_Section_ShZ
    F_Tehai_Code_ntrm = Enum_Sh_Zaiko.F_Tehai_Code_ShZ
    F_System_TanaNO_ntrm = Enum_Sh_Zaiko.F_System_TanaNO_ShZ
    F_Kishu_ntrm = Enum_Sh_Zaiko.F_kishu_ShZ
    F_Store_Code_ntrm = Enum_Sh_Zaiko.F_Store_Code_ShZ
    F_Tana_Text_ntrm = Enum_Sh_Zaiko.F_Tana_Text_ShZ
    F_System_Name_ntrm = Enum_Sh_Zaiko.F_System_Name_ShZ
    F_System_Spec_ntrm = Enum_Sh_Zaiko.F_System_Spec_ShZ
    F_Store_Unit_ntrm = Enum_Sh_Zaiko.F_Store_Unit_ShZ
    F_Manege_Section_sub_ntrm = Enum_Sh_Zaiko.F_Manege_Section_Sub_ShZ
    F_System_Description_ntrm = Enum_Sh_Zaiko.F_System_Description_ShZ
End Enum
'�I��CSV�t�@�C��
'T_M_Parts�Ƃ͕ʂɃf�[�^�����̂ŁA����قǋC�ɂ��Ȃ��Ă���������
'F_CSV_ID    �i�I�[�g�C���N�������g�j
'�m�n�D         �Ǝ�
'�I�����ؓ�     ���[�J��
'�Ǘ��ۋL��     ����
'�T�u�R�[�h
'��z�R�[�h     ����
'�i��
'�^�i
'�I�� ����
'���P�[�V����   ����
'�����L�� ����
'�݌ɐ�
'���i�c         ���[�J������
'DB�i�[�e�[�u����
Public Const T_INV_CSV As String = "T_INV_CSV"                                                      '�I��CSV�t�@�C�����i�[����e�[�u����
Public Const F_INV_CSV_ID As String = "F_CSV_ID"
Public Const F_INV_CSV_ENDDAY As String = "�I�����ؓ�"
Public Const F_INV_CSV_NO As String = "�m�n�D"
Public Const F_INV_CSV_MANEGE_SECTION = F_SH_ZAIKO_MANEGE_SECTON
Public Const F_INV_CSV_MANEGE_SECTION_SUB = "�T�u�R�[�h"
Public Const F_INV_CSV_TEHAI_TEXT = F_SH_ZAIKO_TEHAI_TEXT
Public Const F_INV_CSV_SYSTEM_NAME As String = "�i��"
Public Const F_INV_CSV_SYSTEM_SPEC As String = "�^�i"
Public Const F_INV_CSV_SYSTEM_TANA_NO = F_SH_ZAIKO_SYSTEM_TANA_NO
Public Const F_INV_CSV_LOCATION_TEXT = F_SH_ZAIKO_TANA_TEXT
Public Const F_INV_CSV_STORE_CODE = F_SH_ZAIKO_STORE_CODE
Public Const F_INV_CSV_STOCK_AMOUNT As String = "�݌ɐ�"
Public Const F_INV_CSV_AVAILABLE_AMOUNT As String = "���i�c"
Public Const F_INV_CSV_STATUS As String = "F_CSV_Status"                                            '�`�F�b�N��ԃt���O���Ǘ�����Long�A�Ǝ��t�B�[���h
Public Const F_INV_CSV_BIN_AMOUNT As String = "F_CSV_BIN_Amount"                                    'BIN�J�[�h�c�����L�^����t�B�[���h�A�Ǝ��t�B�[���h
'CSV Enum Inv CSv file
'3�ȊO�͋��ʂȂ̂ŋ���(?)
Public Enum Enum_CSV_Tana_Field
    F_EndDay_ICS = 100
    F_CSV_No_ICS = 101
    F_Available_ICS = 102
    '���P�[�V�������������h�E�Ȃ̂œƎ��ɔԍ��U��
    F_Location_Text_ICS = 103
    F_Status_ICS = 104
    F_Bin_Amount_ICS = 105
    '�ȉ��͋��ʃt�B�[���h
    F_ManegeSection_ICS = Enum_INV_M_Parts.F_Manege_Section_IMPrt
    F_ManegeSection_Sub_ICS = Enum_INV_M_Parts.F_Manege_Section_Sub_IMPrt
    F_Tehai_Code_ICS = Enum_INV_M_Parts.F_Tehai_Code_IMPrt
    F_System_Name_ICS = Enum_INV_M_Parts.F_System_Name_IMPrt
    F_System_Spec_ICS = Enum_INV_M_Parts.F_System_Spec_IMPrt
    F_System_Tana_NO_ICS = Enum_INV_M_Parts.F_System_TanaNo_IMPrt
    F_Store_Code_ICS = Enum_INV_M_Parts.F_Store_Code_IMPrt
    F_Stock_Amount_ICS = Enum_INV_M_Parts.F_Stock_Amount_IMPrt
End Enum
'�I��CSV�t�@�C����Trim�K�v�ȃt�B�[���h�̒萔��񋓂��� Csv need TRiM _ctrm
Public Enum Enum_INV_CSV_Need_Trim
    F_EndDay_ctrm = Enum_CSV_Tana_Field.F_EndDay_ICS
    F_Manege_Section_ctrm = Enum_CSV_Tana_Field.F_ManegeSection_ICS
    F_Manege_Section_Sub_ctrm = Enum_CSV_Tana_Field.F_ManegeSection_Sub_ICS
    F_Tehai_Code_ctrm = Enum_CSV_Tana_Field.F_Tehai_Code_ICS
    F_System_Name_ctrm = Enum_CSV_Tana_Field.F_System_Name_ICS
    F_System_Spec_ctrm = Enum_CSV_Tana_Field.F_System_Spec_ICS
    F_System_Tana_No_ctrm = Enum_CSV_Tana_Field.F_System_Tana_NO_ICS
    F_Location_Text_ctrm = Enum_CSV_Tana_Field.F_Location_Text_ICS
    F_Store_Code_ctrm = Enum_CSV_Tana_Field.F_Store_Code_ICS
End Enum
'���x���o�͗p�ꎞ�e�[�u����
Public Const T_INV_LABEL_TEMP As String = "T_INV_LABEL_TEMP"                                        '���x���o�͗p�̍������݈���p�e�[�u���̖��O
'���x���o�͗p�ꎞ�e�[�u����p�t�B�[���h��`
Public Const F_INV_LABEL_TEMP_TEHAICODE_LENGTH As String = "F_INV_Tehaicode_Length"                 '���x���o�݂͂̂Ɏg�p����v�Z��A��z�R�[�h�̕����񐔂��i�[
Public Const F_INV_LABEL_TEMP_ORDERNUM As String = "F_INV_OrderNumber"                              '���x���o�݂͂̂Ɏg�p����I�[�_�[No��
Public Const F_INV_LABEL_TEMP_SAVEPOINT As String = "F_INV_Label_Savepoint"                         '���x���o�݂͂̂Ɏg�p����Savepoint�A�o�̓��X�g�̔��ʂɎg�p����
Public Const F_INV_LABEL_TEMP_SAVE_FRENDLYNAME As String = "���ʖ�"                                 'SavePoint�o�͎��� Savepoint�t�����h���[�l�[��
Public Const F_INV_LABEL_TEMP_INPUT_FRENDLYNAME As String = "���͓���"                              'SavePoint�o�͎��AInputDate�t�����h���[�l�[��
Public Const F_INV_LABEL_TEMP_FORMSTARTTIME As String = "F_INV_Label_FormStartTime"                 'FormStartTime���L�^
Public Const F_INV_LABEL_TEMP_FRMSTART_FRENDLYNAME As String = "�t�H�[���J�n����"                   'FormStartTime�t�����h���[�l�[��
'------------------------------------------------------------------------------------------------------------------------------------------------------
'DB Upsert�����萔
Public Const SQL_ALIAS_T_INVDB_Parts As String = "TDBPrts"                                          'INV_M_Parts�e�[�u���ʖ���`
Public Const SQL_ALIAS_T_INVDB_Tana As String = "TDBTana"                                           'INV_M_Tana�e�[�u���ʖ���`
Public Const SQL_ALIAS_T_TEMP As String = "TTmp"                                                    '�ꎞ�e�[�u���ʖ���`
Public Const SQL_ALIAS_T_SH_ZAIKO As String = "TSHZaiko"                                            '�݌ɏ��V�[�g�e�[�u�����ʖ���`
Public Const SQL_ALIAS_T_INV_CSV As String = "TCSVTana"                                             '�I��CSV�e�[�u���̕ʖ���`
Public Const SQL_ALIAS_SH_CSV As String = "SHCSV"                                                   '�I��CSV�t�@�C�����̂��̂̕ʖ���`
'SQLAliasEnum
Public Enum Enum_SQL_INV_Alias
    INVDB_Parts_Alias_sia = 1
    INVDB_Tana_Alias_sia = 2
    INVDB_Tmp_Alias_sia = 3
    ZaikoSH_Alias_sia = 4
    TanaCSV_Alias_sia = 5
    SHCSV_Alias_sia = 6
End Enum
Public Const SQL_AFTER_IN_ACCDB_0FullPath As String = "[MS ACCESS;DATABASE={0};]"                   'Select From �� IN""��̌�ɗ��镶����accdb
Public Const SQL_AFTER_IN_XLSM_0FullPath As String = "[Excel 12.0 Macro;DATABASE={0};HDR=Yes;]"     'In xlsm,xlam
Public Const SQL_AFTER_IN_XLSB_0FullPath As String = "[Excel 12.0;DATABASE={0};HDR=Yes;]"           'IN xlsb
Public Const SQL_AFTER_IN_XLSX_0FullPath As String = "[Excel 12.0 xml;DATABASE={0};HDR=Yes;]"       'IN xlsx
Public Const SQL_AFTER_IN_XLS_0FullPath As String = "[Excel 8.0;DATABASE={0};HDR=Yes;]"             'IN xls
'SQL��`
'------------------------------------------------------------------------------------------
'��z�R�[�h�擪n�������X�g�擾
Public Const SQL_INV_TEHAICODE_n_0TableName_1DigitNum As String = "SELECT DISTINCT LEFT(" & F_SH_ZAIKO_TEHAI_TEXT & ",{1}) FROM {0}"             '0�Ƀe�[�u����������
'------------------------------------------------------------------------------------------
'SH_Zaiko��T_INV_Tmp�ɓ����
'�݌ɏ��V�[�g�̂݊O���t�@�C���Q�ƂȂ̂ŁAIN��Ŏw�肵�Ă��
'IN�̌�̓_�u���N�H�[�e�[�V�����ӂ��A�t�@�C�����ɋ󔒂������Ă��G�X�P�[�v����K�v�Ȃ�?
'T_INV_Tmp�����݂��Ă�����G���[�ɂȂ�̂Ŏ��O�ɍ폜���K�v
Public Const SQL_INV_SH_TO_DB_TEMPTABLE_0Table_1INword As String = "SELECT * INTO " & T_INV_TEMP & " " & vbCrLf & _
"FROM " & vbCrLf & _
    "(SELECT * FROM {0} " & vbCrLf & _
    "IN """"{1} ) "
'
''------------------------------------------------------------------------------------------
'DISTINCT ���P�[�V���� �������ʂ��ꎞ�e�[�u���ɓ����
''�ǂ��������DB�t�@�C����ɂ���̂œ��iIN��̎w��̕K�v�Ȃ�
'SELECT DISTINCT �̌��ʂ��ꎞ�e�[�u���ɓ����
'���O��T_INV_SELECT_TEMP�̍폜���K�v
Public Const SQL_INV_SELECT_DISTINCT_TO_TEMPTABLE_0FieldName As String = "SELECT * INTO " & T_INV_SELECT_TEMP & " " & vbCrLf & _
"FROM ( " & vbCrLf & _
    "SELECT DISTINCT TRIM({0}) AS {0} FROM " & T_INV_TEMP & " " & vbCrLf & _
    "WHERE IIF(ISNULL(TRIM({0})),""NULL_DATA"",TRIM({0})) <> ""NULL_DATA"" AND IIF(ISNULL(TRIM({0})),""NULL_DATA"",TRIM({0})) <>  """"" & vbCrLf & _
")"
''------------------------------------------------------------------------------------------
'�ꎞ�e�[�u����ZaikoSH��INV_M_Tana�ɓ����
''�ꎞ�e�[�u�����쐬������ł�Update�͐���
'�O��DB����͌��Ɏg���ꍇ�́AIN���FROM�̌�łȂ���Γ����Ȃ��悤�Ȃ̂ŁA�T�u�N�G����(SELECE * FROM Tname IN�E�E�E) as TAlias �Ƃ��Ă��Ȃ��ƃ_��
Public Const SQL_INV_TEMP_TO_M_TANA_0INVDBFullPath_1LocalTimeMillisec As String = "UPDATE " & T_INV_M_Tana & " AS " & SQL_ALIAS_T_INVDB_Tana & " " & vbCrLf & _
"RIGHT JOIN ( " & vbCrLf & _
"SELECT *  FROM " & T_INV_SELECT_TEMP & " " & vbCrLf & _
"IN """"[MS ACCESS;DATABASE={0};] ) AS " & SQL_ALIAS_T_TEMP & " " & vbCrLf & _
"ON " & SQL_ALIAS_T_INVDB_Tana & "." & F_INV_TANA_SYSTEM_TEXT & " = " & SQL_ALIAS_T_TEMP & "." & F_SH_ZAIKO_TANA_TEXT & " " & vbCrLf & _
"Set " & SQL_ALIAS_T_INVDB_Tana & "." & F_INV_TANA_SYSTEM_TEXT & " = " & SQL_ALIAS_T_TEMP & "." & F_SH_ZAIKO_TANA_TEXT & "," & vbCrLf & _
SQL_ALIAS_T_INVDB_Tana & "." & PublicConst.INPUT_DATE & " = {1} " & vbCrLf & _
"WHERE " & F_INV_TANA_SYSTEM_TEXT & " Is Null"
''------------------------------------------------------------------------------------------
'T_INV_M_Parts��Upsert����SQL ���͌��� T_INV_Tana �� T_INV_Tmp
'3�̃e�[�u����Join����Select,�������
'SELECT TDBTana.*,TTmp.*,TDBTana.*
'FROM T_INV_M_Parts AS TDBPrts
'RIGHT JOIN (
'    T_INV_M_Tana As TDBTana
'        RIGHT JOIN (
'        SELECT * FROM  T_INV_Temp
'        IN ""[MS ACCESS;DATABASE=C:\Users\q3005sbe\AppData\Local\Rep\InventoryManege\bin\Inventory_DB\DB_Temp_Local.accdb;] ) AS TTmp
'        ON TDBTana.F_INV_Tana_System_Text = TTmp.[���P�[�V����])
'    ON TDBPrts.F_INV_Tehai_Code = TTmp.��z�R�[�h;
'�u���T���v��
'SELECT {3}.*,{5}.*,{3}.*
'FROM {0} AS {1}
'RIGHT JOIN (
'    {2} As {3}
'        RIGHT JOIN (
'        SELECT * FROM  {4}
'        IN ""[MS ACCESS;DATABASE={6};] ) AS {5}
'        ON {3}.{7} = {5}.{8})
'    ON {1}.{9} = {5}.{10};
'
'T_INV_M_Parts                      {0}
'TDBPrts                            {1}
'T_INV_M_Tana                       {2}
'TDBTana                            {3}
'T_INV_Temp                         {4}
'TTmp                               {5}
'(CreateAfterINWord(DB_Temp.accdb)  {6}
'(ON Condition Tana and TTmp)       {7}
'(ON Condition Parts and TTmp)      {8}
'F_INV_Tana_ID                      {9}
'(SET Condition Parts and TTmp)     {10}
'(WHERE condition Parts ad TTmp)    {11}
'F_INV_Tehai_Code                   {12}
'{13} InputDate
'{14} (GetLocaltimeWithMilliSec)
Public Const SQL_INV_UPSERT_PARSTABL_FROM_TTMP_AND_TANA As String = "UPDATE  {0} AS {1} " & vbCrLf & _
"RIGHT JOIN ( " & vbCrLf & _
"   {2} As {3} " & vbCrLf & _
"   RIGHT JOIN ( " & vbCrLf & _
"       SELECT * FROM  {4} " & vbCrLf & _
"       IN """"{6} ) AS {5}" & vbCrLf & _
"   ON {7} ) " & vbCrLf & _
"ON {8} " & vbCrLf & _
"SET {1}.{9} = IIF(ISNULL({3}.{9}),-1,{3}.{9}),{1}.{13} = ""{14}"",{10} " & vbCrLf & _
"WHERE ISNULL({1}.{12}) OR {11} ;"
'T_INV_M_Tana��T_INV_M_Parts���������ėpSELECT SQL�A�O��DB�t�@�C���Q�Ƃ͖������̂Ƃ���
'{0}    (SELECT Field)
'{1}    T_INV_M_Parts
'{2}    TDBPrts
'{3}    T_INV_M_Tana
'{4}    TDBTana
'{5}    F_INV_Tana_ID
'{6}    (WHERE condition)�����̏ꍇ�͋󕶎� "" ��OK
Public Const SQL_INV_JOIN_TANA_PARTS As String = "SELECT {0} " & vbCrLf & _
"FROM {1} AS {2} " & vbCrLf & _
"   LEFT JOIN {3} AS {4} " & vbCrLf & _
"   ON {2}.{5} = {4}.{5} " & vbCrLf & _
"WHERE 1=1 {6} ;"
'Tana�}�X�^�[�ŁALocal_text���󗓂̕����ꊇ��System_Text�̂��̂ɐݒ肷��
'{0}    T_INV_M_Tana
'{1}    TDBTana
'{2}    (SET condition) TDBTana.F_INV_LOCAL_TEXT = TDBTana.F_INV_SYSTEM_Text
'{3}    (WHERE condition) AND TDBTana.LOCAL_TExt IS NULL
Public Const SQL_INV_TANA_SET_LOCAL_TEXT_BY_SYSTEM As String = "UPDATE {0} AS {1} " & vbCrLf & _
"SET {2} " & vbCrLf & _
"WHERE 1=1 {3}"
'------------------------------------------------------------------------------------------------
'TanaCSV��TTmp�ɓ���āA�Ȃ����I�����ؓ��t�B�[���h�ǉ����āA�f�[�^���ꂽ��ɍX�V������SQL�ЂȌ`
'�|�C���g�́AJOIN �� ON ������ AND��2�w��ƁAWhere�� ���e�[�u���̒I�����ؓ��� Is Null��t���邱��
'UPDATE T_INV_CSV AS TCSVTana
'   RIGHT JOIN (
'      SELECT * FROM T_INV_Temp
'         IN ""[MS ACCESS;DATABASE=c:\users\....] ) AS Ttmp
'   ON TCSVTana.��z�R�[�h = Ttmp.��z�R�[�h AND TCSVTana.�I�����ؓ� = Ttmp.�I�����ؓ�
'SET TCSVTana.�I�����ؓ� = "2022/02/02",TCSVTana.----
'WHERE TCSVTana.�I�����ؓ� Is Null
'{0}    T_INV_CSV
'{1}    TCSVTana
'{2}    T_INV_Temp
'{3}    (After IN Word)
'{4]    Ttmp
'{5}    ��z�R�[�h
'{6]    (SET condition)
'{7}    �I�����ؓ�
Public Const SQL_INV_TMP_TO_CSVTANA As String = "UPDATE {0} AS {1} " & vbCrLf & _
"   RIGHT JOIN (" & vbCrLf & _
"       SELECT * FROM {2} " & vbCrLf & _
"           IN """"{3} ) AS {4} " & vbCrLf & _
"   ON {1}.{5} = {4}.{5} AND {1}.{7} = {4}.{7} " & vbCrLf & _
"SET {6} " & vbCrLf & _
"WHERE {1}.{7} Is Null"
'------------------------------------------------------------------------------------------------
'DB����CSV(xls)�t�@�C���Ƀf�[�^�Z�b�g����SQL
'�J�����g�f�B���N�g���̓V�[�g�t�@�C���̂��̂ɂ���
'UPDATE ['SIZ_TANAOROSI_HYO - �R�s�[_Local$'_xlnm#_FilterDatabase] AS SHCSV
'    RIGHT JOIN (
'        SELECT * FROM T_INV_CSV
'        IN "" [MS ACCESS;DATABASE=C:\Users\q3005sbe\AppData\Local\Rep\InventoryManege\bin\Inventory_DB\INV_Manege_Local.accdb]
'        WHERE �I�����ؓ� = "2022/01/12"
'        ) AS TCSVTana
'    ON SHCSV.��z�R�[�h = TCSVTana.��z�R�[�h
'Set SHCSV.���i�c = TCSVTana.���i�c
'{0}    (Sheet Table Name)
'{1}    SHCSV
'{2}    T_INV_CSV
'{3}    (After In Word Default DB)
'{4}    �I�����ؓ�
'{5}    (2022/01/12 EndDay)
'{6}    TCSVTana
'{7}    ��z�R�[�h
'{8}    ���i�c
Public Const SQL_INV_DB_TO_CSV As String = "UPDATE {0} AS {1}" & vbCrLf & _
"    RIGHT JOIN (" & vbCrLf & _
"        SELECT * FROM {2}" & vbCrLf & _
"        IN """" {3}" & vbCrLf & _
"        WHERE {4} = ""{5}""" & vbCrLf & _
"        ) AS {6}" & vbCrLf & _
"    ON {1}.{7} = {6}.{7}" & vbCrLf & _
"Set {1}.{8} = {6}.{8}"
'------------------------------------------------------------------------------------------------
'���x���o�͗p�ꎞ�e�[�u���쐬SQL
'CREATE TABLE T_INV_LABEL_TEMP (
'    F_INV_Tana_Local_Text CHAR(10),F_INV_Tehai_Code CHAR(50),
'    F_INV_Label_Name_1 CHAR(18),F_INV_Label_Name_2 CHAR(18),F_INV_Label_Remark_1 CHAR(18),F_INV_Label_Remark_2 CHAR(18),InputDate CHAR(23)
')
'{0}    T_INV_LABEL_TEMP
'{1}    F_INV_Tana_Local_Text
'{2}    F_INV_Tehai_Code
'{3}    F_INV_Label_Name_1
'{4}    F_INV_Label_Name_2
'{5}    F_INV_Label_Remark_1
'{6}    F_INV_Label_Remark_2
'{7}    InputDate
'{8}    INV_CONST.F_INV_LABEL_TEMP_TEHAICODE_LENGTH
'{9}    INV_CONST.F_INV_LABEL_TEMP_ORDERNUM
'{10}   INV_CONST.F_INV_LABEL_TEMP_SAVEPOINT
'{11}   INV_CONST.F_INV_LABEL_TEMP_FORMSTARTTIME
Public Const SQL_INV_CREATE_LABEL_TEMP_TABLE As String = "CREATE TABLE {0} (" & vbCrLf & _
"    {10} CHAR(23),{11} CHAR(23),{1} CHAR(15),{2} CHAR(50),{8} LONG," & vbCrLf & _
"    {3} CHAR(18),{4} CHAR(18),{5} CHAR(18),{6} CHAR(18),{9} CHAR(9),{7} CHAR(23)" & vbCrLf & _
")"
'------------------------------------------------------------------------------------------------
'Label_Temp SavePoint�ꗗ�o��SQL
'{0}    F_inv_Label_Savepoint
'{1}    FormStartTime
'{2}    T_inv_Label_Temp
'{3}    INV_CONST.F_INV_LABEL_TEMP_SAVE_FRENDLYNAME
'{4}    INV_CONST.F_INV_LABEL_TEMP_FRMSTART_FRENDLYNAME
Public Const SQL_SELECT_SAVEPOINT As String = "SELECT {0} AS {3},{1} AS {4}  FROM {2} " & vbCrLf & _
"GROUP BY {0},{1} " & vbCrLf & _
"ORDER BY {0} DESC,{1} DESC"
'------------------------------------------------------------------------------------------------
'BinLabel MailMerge�p��b�f�[�^�擾
'{0}    INV_CONST.T_INV_LABEL_TEMP
'{1}    (MailMerge Where)
'{2}    INV_CONST.T_INV_SELECT_TEMP
Public Const SQL_LABEL_MAILMERGE_DEFAULT As String = "SELECT * INTO {2} FROM [{0}] " & vbCrLf & _
"WHERE {1}"