Attribute VB_Name = "INV_CONST"
'''�݌ɊǗ��֌W�̒萔���`����
Option Explicit
'�݌ɏ��DB�Ɋւ���萔
Public Const INV_DB_FILENAME As String = "INV_Manege.accdb"                     '�݌ɏ���DB�t�@�C����
Public Const T_INV_TEMP As String = "T_INV_Temp"                                'INVDB�̈ꎞ�e�[�u����
Public Const T_INV_SELECT_TEMP As String = "T_INV_Select_Temp"                  'Select�������ʂ��i�[����e�[�u�����A��U�e�[�u���Ɋi�[���Ȃ���
                                                                                '�X�V�\�ȃN�G�����E�E�E�Ƃ������邽��
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
    F_INV_TANA_ID_IMT = 1
    F_INV_Tana_Local_Text_IMT = 2
    F_INV_Tana_System_Text_IMT = 3
    F_INV_TIET_Delivary_IMT = 4
    F_InputDate_IMT = 5
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
End Enum
'------------------------------------------------------------------------------------------------------------------------------------------------------
'SQL��`
'��z�R�[�h�擪n�������X�g�擾
Public Const SQL_INV_TEHAICODE_n_0TableName_1DigitNum As String = "SELECT DISTINCT LEFT(" & F_SH_ZAIKO_TEHAI_TEXT & ",{1}) FROM {0}"             '0�Ƀe�[�u����������
'DB Upsert�����萔
Public Const SQL_ALIAS_T_INVDB_Parts As String = "TDBPrts"                                          'INV_M_Parts�e�[�u���ʖ���`
Public Const SQL_ALIAS_T_INVDB_Tana As String = "TDBTana"                                           'INV_M_Tana�e�[�u���ʖ���`
Public Const SQL_ALIAS_T_TEMP As String = "TTmp"                                                    '�ꎞ�e�[�u���ʖ���`
Public Const SQL_ALIAS_T_SH_ZAIKO As String = "TSHZaiko"                                            '�݌ɏ��V�[�g�e�[�u�����ʖ���`
'SQLAliasEnum
Public Enum Enum_SQL_INV_Alias
    INVDB_Parts_Alias_sia = 1
    INVDB_Tana_Alias_sia = 2
    INVDB_Tmp_Alias_sia = 3
    ZaikoSH_Alias_sia = 4
End Enum
Public Const SQL_AFTER_IN_ACCDB_0FullPath As String = "[MS ACCESS;DATABASE={0};]"                   'Select From �� IN""��̌�ɗ��镶����accdb
Public Const SQL_AFTER_IN_XLSM_0FullPath As String = "[Excel 12.0 Macro;DATABASE={0};HDR=Yes;]"     'In xlsm,xlam
Public Const SQL_AFTER_IN_XLSB_0FullPath As String = "[Excel 12.0;DATABASE={0};HDR=Yes;]"           'IN xlsb
Public Const SQL_AFTER_IN_XLSX_0FullPath As String = "[Excel 12.0 xml;DATABASE={0};HDR=Yes;]"       'IN xlsx
Public Const SQL_AFTER_IN_XLS_0FullPath As String = "[Excel 8.0;DATABASE={0};HDR=Yes;]"             'IN xls
'�݌ɏ��V�[�g�̂݊O���t�@�C���Q�ƂȂ̂ŁAIN��Ŏw�肵�Ă��
'IN�̌�̓_�u���N�H�[�e�[�V�����ӂ��A�t�@�C�����ɋ󔒂������Ă��G�X�P�[�v����K�v�Ȃ�?
'SELECT TSHZaiko.��z�R�[�h,TDBTana.F_INV_Tana_ID,TDBTana.F_INV_Tana_Local_Text,TDBTana.F_INV_Tana_System_Text
'FROM    (
'    SELECT * FROM T_INV_M_Tana
'    IN ""[MS ACCESS;DATABASE=R:\Tmp\Patacchi\Test Dir\INV_Manege_Local.accdb;]
'    ) AS TDBTana
'RIGHT JOIN (
'    SELECT * FROM [�݌ɏ��$FilterDatabase]
'    IN ""[Excel 12.0;DATABASE=R:\Tmp\Patacchi\Test Dir\Zaiko_0_Local.xls;]
'    ) AS TSHZaiko
'ON TDBTana.F_INV_Tana_System_Text = TSHZaiko.���P�[�V����
'WHERE NOT TDBTana.F_INV_Tana_ID IS NULL;
''------------------------------------------------------------------------------------------
''�O���f�[�^��V�K�e�[�u���Ƃ��ăC���|�[�g����
''T_Temp�����݂��Ă�����G���[�ɂȂ�̂Ŏ��O�ɍ폜���K�v
Public Const SQL_INV_SH_TO_DB_TEMPTABLE_0Table_1INword As String = "SELECT * INTO " & T_INV_TEMP & " " & vbCrLf & _
"FROM " & vbCrLf & _
    "(SELECT * FROM {0} " & vbCrLf & _
    "IN """"{1} ) "
'
''------------------------------------------------------------------------------------------
''�ǂ��������DB�t�@�C����ɂ���̂œ��iIN��̎w��̕K�v�Ȃ�
'SELECT * INTO T_INV_Temp_Select
'FROM (
'    SELECT DISTINCT ���P�[�V���� FROM T_INV_Temp
')
'SELECT DISTINCT �̌��ʂ��ꎞ�e�[�u���ɓ����
'���O��T_INV_SELECT_TEMP�̍폜���K�v
Public Const SQL_INV_SELECT_DISTINCT_TO_TEMPTABLE_0FieldName As String = "SELECT * INTO " & T_INV_SELECT_TEMP & " " & vbCrLf & _
"FROM ( " & vbCrLf & _
    "SELECT DISTINCT {0} FROM " & T_INV_TEMP & vbCrLf & _
")"
''------------------------------------------------------------------------------------------
''�ꎞ�e�[�u�����쐬������ł�Update�͐���
'UPDATE T_INV_M_Tana AS TDBTana
'RIGHT JOIN (
'SELECT * FROM T_INV_Temp
'IN ""[MS ACCESS;DATABASE=C:\Users\q3005sbe\AppData\Local\Rep\InventoryManege\bin\Inventory_DB\DB_Temp_Local.accdb;] ) AS TDBTemp
'ON TDBTana.F_INV_Tana_System_Text = TDBTemp.���P�[�V����
'Set TDBTana.F_INV_Tana_System_Text = TDBTemp.���P�[�V����,
'TDBTana.InputDate = "2022-01-25T16.20:00.010"
'WHERE F_INV_Tana_System_Text Is Null
Public Const SQL_INV_TEMP_TO_M_TANA_0INVDBFullPath_1LocalTimeMillisec As String = "UPDATE " & T_INV_M_Tana & " AS " & SQL_ALIAS_T_INVDB_Tana & " " & vbCrLf & _
"RIGHT JOIN ( " & vbCrLf & _
"SELECT *  FROM " & T_INV_SELECT_TEMP & " " & vbCrLf & _
"IN """"[MS ACCESS;DATABASE={0};] ) AS " & SQL_ALIAS_T_TEMP & " " & vbCrLf & _
"ON " & SQL_ALIAS_T_INVDB_Tana & "." & F_INV_TANA_SYSTEM_TEXT & " = " & SQL_ALIAS_T_TEMP & "." & F_SH_ZAIKO_TANA_TEXT & " " & vbCrLf & _
"Set " & SQL_ALIAS_T_INVDB_Tana & "." & F_INV_TANA_SYSTEM_TEXT & " = " & SQL_ALIAS_T_TEMP & "." & F_SH_ZAIKO_TANA_TEXT & "," & vbCrLf & _
SQL_ALIAS_T_INVDB_Tana & "." & PublicConst.INPUT_DATE & " = {1} " & vbCrLf & _
"WHERE " & F_INV_TANA_SYSTEM_TEXT & " Is Null"
''------------------------------------------------------------------------------------------
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
'
'T_INV_M_Parts   {0}
'TDBPrts {1}
'T_INV_M_Tana {2}
'TDBTana     {3}
'T_INV_Temp  {4}
'TTmp    {5}
'C:\Users\q3005sbe\AppData\Local\Rep\InventoryManege\bin\Inventory_DB\DB_Temp_Local.accdb    {6}
'F_INV_Tana_System_Text  {7}
'���P�[�V����    {8}
'F_INV_Tehai_Code    {9}
'��z�R�[�h  {10}