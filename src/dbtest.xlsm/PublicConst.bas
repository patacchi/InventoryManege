Attribute VB_Name = "PublicConst"
Option Explicit
'Option Base 1
'office 2013�����ɂ��Amdb����accdb�`���Ɉڍs
'DB��SQLite3�Ɉڍs  2021_01_10 Pataccchi
Public Const constDatabasePath              As String = "\\toshiba.local\adsf\tdms_js_js\�i�����jSMT�O���[�v\SMT�v��#2\���ʎY(LINE4)\JobNumberManege\bin\Database_sqlite3"      '�f�[�^�x�[�X�f�B���N�g��
Public Const constJobNumberDBname           As String = "JobNumberDB.sqlite3"   '�W���u�ԍ����DB�̃t�@�C����
Public Const Field_Initialdate              As String = "InitialInputDate"      '�e�e�[�u�����ʁA������͎���
Public Const Field_Update                   As String = "UpdateDate"            '�e�e�[�u�����ʁA�ŏI�X�V����
Public Const Field_BarcordeNumber           As String = "BarcodeNumber"         '�e�[�u�����ʁA�g���TID�o�[�R�[�h�f�[�^
Public Const Field_LocalInput               As String = "LocalInput"            '�e�[�u�����ʁA���[�J�����͎� 1�i���[�J���E�����[�g�o�b�N�A�b�v����j
Public Const Field_RemoteInput              As String = "RemoteInput"           '�e�[�u�����ʁA�����[�g���͎� 1�i���������{�̂ɂȂ�͂��j
'�W���u�ԍ��Ǘ�DB�e�[�u���E�t�B�[���h����`
'Json�e�[�u��
Public Const Table_JSON                     As String = "T_JSON"                'JSON���i�[�e�[�u��
Public Const JSON_Field_Name                As String = "Name"                  'JSON���[�g���ʖ� TEXT NOT NULL UNIQUE
Public Const JSON_Field_string              As String = "JSON_String"           'JSON�{�̊i�[
'�@��ʏ��i�[�e�[�u����`
Public Const Table_Kishu                    As String = "T_Kishu"               '�@��ʏ��i�[�e�[�u����
Public Const Kishu_Header                   As String = "KishuHeader"           '�@�픻�ʗp�w�b�_���t�B�[���h�i�d���s�j
Public Const Kishu_KishuName                As String = "KishuName"             '�@�햼�t�B�[���h P70664A
Public Const Kishu_KishuNickname            As String = "KishuNickName"         '�@��ʏ̖� �}�X�^�[
Public Const Kishu_TotalKeta                As String = "TotalRirekiketa"       '�������t�B�[���h�i����20�����Ȃ��Ǝv���j
Public Const Kishu_RenbanKetasuu            As String = "RenbanKetasuu"         '�A�Ԍ����t�B�[���h
Public Const Kishu_Mai_Per_Sheet            As String = "Mai_Per_Sheet"         '1�V�[�g������̖���
Public Const Kishu_Sheet_Per_Rack           As String = "Sheet_Per_Rack"        '1���b�N������̃V�[�g��
Public Const Kishu_Barcord_Read_Number      As String = "Barcord_Read_Number"   '�o�[�R�[�h�ǂݎ�萔
'���O���i�[�e�[�u����`
'���O�͊�{�I�Ƀg���K�[�œ��͂���
Public Const Table_Log                      As String = "T_Log"                 '���O���e�[�u����
Public Const Log_ActionType                 As String = "ActionType"            'INSERT,UPDATE,DELETE�̂����ꂩ������
Public Const Log_Table                      As String = "TableName"             '�e�[�u����
Public Const Log_StartRireki                As String = "StartRireki"           '(INSERT)�J�n����
Public Const Log_Maisuu                     As String = "Maisuu"                '(INSERT)����
Public Const Log_JobNumber                  As String = "JobNumber"             '(INSERT) T_JobData_ �W���u�ԍ�
Public Const Log_RirekiHeader               As String = "RirekiHeader"          '(INSERT) T_JobData_ �����w�b�_
Public Const Log_BarcordNumber              As String = "BarcodeNumber"         '(INSERT) T_Barcode_ �o�[�R�[�h�ԍ�
Public Const Log_SQL                        As String = "SQL"                   '(UPDATE,DELETE)���̏ꍇ��SQL�̂݊i�[
'�W���u�E�������e�[�u����`
Public Const Table_JobDataPri               As String = "T_JobData_"            '�W���u�����e�[�u�����O�������A���ۂ͂��̌�ɋ@�햼���A������ăe�[�u�����ƂȂ�
Public Const Job_Number                     As String = "JobNumber"             '�W���u�ԍ��t�B�[���h��
Public Const Job_RirekiHeader               As String = "RirekiHeader"          '�����w�b�_�t�B�[���h��
Public Const Job_RirekiNumber               As String = "RirekiNumber"          '�����̘A�ԕ����iLong�Ŋi�[�j
Public Const Job_Rireki                     As String = "Rireki"                '�w�b�_+����A�ԁi�쐬���邩�v�����j
Public Const Job_KanbanChr                  As String = "KanbanChr"             '�J���o������������
Public Const Job_KanbanNumber               As String = "KanbanNumber"          '�J���o�������ԍ�(B) 30���R�R Integer
Public Const Job_ProductDate                As String = "ProductDate"           '�����\����i�v��������ĂɎg���j
'�������͑S���@��ʂɃe�[�u���𕪂���
'�ʏ�o�[�R�[�h�L�^�e�[�u��
Public Const Table_Barcodepri               As String = "T_Barcode_"            '�@��ʃo�[�R�[�h���͏��e�[�u���A���ۂ͌㔼�ɋ@�햼���A�������
Public Const Laser_Rireki                   As String = "LaserRirekiNumber"       '���[�U�[�̗���ԍ��i�[�t�B�[���h�iLong�Ŋi�[�j�A�d���s��
'�Ĉ󎚓��o�[�R�[�h�L�^�e�[�u��
Public Const Table_Retrypri                 As String = "T_Retry_"              '�@��ʍĈ󎚃o�[�R�[�h�����i�[�e�[�u���A���ۂ͌㔼�ɋ@�햼���A�������
Public Const Retry_Rireki                   As String = "LaserRetryRireki"      '�Ĉ󎚂̗����t�B�[���h���iLong�Ŋi�[�j�A�Ĉ󎚂͗����d��OK
Public Const Retry_Reason                   As String = "RetryReason"           '�Ĉ󎚗��R�t�B�[���h
'�t�B�[���h�ǉ��pSQL��^��
Public Const strOLDAddField1_NextTableName     As String = "ALTER TABLE """        '�ǉ��̍ŏ��A���̎��Ƀe�[�u����������
Public Const strOLDAddField2_NextFieldName     As String = """ ADD COLUMN """      '��ԖځA���̎��Ƀt�B�[���h��������
Public Const strOLDAddField3_Text_Last         As String = """ TEXT;"              '�Ō�A������TEXT�^�̏ꍇ
Public Const strOLDAddField3_Numeric_Last      As String = """ NUMERIC;"           '���l�̏ꍇ�̍Ō�
Public Const strOLDAddField3_JSON_Last         As String = """ JSON;"              'JSON���X�g
'�C���f�b�N�X�ǉ��pSQL��^��
Public Const strOLDIndex1_NextTable            As String = "CREATE INDEX IF NOT EXISTS ""ixJob_"
Public Const strOLDIndex2_NextTable            As String = """ ON """
Public Const strOLDIndex3_Field1               As String = """ ("""
Public Const strOLDIndex4_FieldNext            As String = """ ASC ,"""            '�����t�B�[���h�ɑ΂��Ď��s����ꍇ�́A�Ȍケ��̌J��Ԃ�
Public Const strOLDIndex5_Last                 As String = """ ASC);"
'�e�[�u���ǉ��pSQL��^��
Public Const strTable1_NextTable                As String = "CREATE TABLE IF NOT EXISTS " 'CRLF�t���A����уt�B�[���h����ǉ��Ή��e���v��
Public Const strTable2_Next1stField             As String = " (" & vbCrLf           'CRLF�Ή��쐬�e���v���A��������g���ꍇ��AddQuote���g���ăG�X�P�[�v�������邱��
'�t�B�[���h��`�A�t�B�[���h���i�N�I�[�g�j��3(�^��)��[Append](�e�퐧��A�����)��(EndRow)�̗���
Public Const strTable3_TEXT                     As String = " TEXT "                '�O��TEXT
Public Const strTable3_NUMERIC                  As String = " NUMERIC "             '�O��NUMERIC
Public Const strTable3_JSON                     As String = " JSON "                '�O��JSON
Public Const strTable_NotNull                   As String = " NOT NULL "            'NOT NULL����ǉ�
Public Const strTable_Unique                    As String = " UNIQUE "              'UNIQUE����ǉ�
Public Const strTable_Default                   As String = " DEFAULT "             'DEFAULT�ǉ��A���̌�Ƀf�t�H���g�l���N�I�[�g�������Ēǉ����邱��
Public Const strTable4_EndRow                   As String = "," & vbCrLf            '�s�̏I���A�܂�����������ꍇ
Public Const strTable5_EndSQL                   As String = ");" & vbCrLf           'SQL���̏I���
Public Const strOLDAddTable1_NextTable          As String = "CREATE TABLE IF NOT EXISTS """ '�e�[�u���ǉ��p��^����������
Public Const strOLDAddTable2_Field1_Next_Field  As String = """ ("""                '�t�B�[���h�̍ŏ������������g���A���ɍŏ��̃t�B�[���h��
Public Const strOLDAddTable_TEXT_Next_Field     As String = """ TEXT,"""            '����킵�����ǁA�u�O�v��Text�^�̏ꍇ���������g���A���Ƀt�B�[���h��������
Public Const strOLDAddTable_TEXT_UNIQUE_Next_Field As String = """ TEXT UNIQUE,"""  '�O��TEXT ���� UNIQUE�̏ꍇ
Public Const strOLDAddTable_NUMELIC_Next_Field  As String = """ NUMERIC,"""         '�u�O�v��Numeric�̏ꍇ�͂�����
Public Const strOLDAddTable_Text_Last           As String = """ TEXT);"             '�����h�E�Ȃ̂ŁA�Ō��Text�ŏI��点�āE�E�E
Public Const strOLDAddTable_Numeric_Last        As String = """ NUMERIC);"          '�ꉞ���l�^�ŏI�����
'�V�[�g���i�[�֌W�萔
Public Const constMaisuu_Label                  As String = "Maisuu"                '���𖇐��i�P�ƃZ���Q�Ɓj���O��`
Public Const constRirekiFromLabel               As String = "Rireki_From"           '����From�i�P�ƃZ���Q�Ɓj���O��`
Public Const constRirekiToLabel                 As String = "Rireki_To"             '����To�i�P�ƃZ���Q�Ɓj���O��`
Public Const constMaxRirekiKetasuu              As Byte = 20                        '����������Max�l
Public Const constDefaultArraySize              As Long = 6000                      'DB����̌��ʃZ�b�g�̔z��̏������
Public Const constAddArraySize                  As Long = 2000                      '�z��m�ۍs��������Ȃ��Ȃ����ꍇ��1��ő��ʂ��镪
'�G���[�R�[�h��`�i�����g��Ȃ������E�E�E
Public Const errcNone                       As Integer = 0                      '����I��
Public Const errcDBAlreadyExistValue        As Integer = -2                      '���ɓ����l��DB��ɗL��ꍇ
Public Const errcDBFileNotFound             As Integer = -4                      'DB�t�@�C��������Ȃ��患
Public Const errcDBFieldNotFont             As Integer = -8                      'DB�Ŏw�肳�ꂽ�t�B�[���h��������Ȃ�
Public Const errcxlNameNotFound             As Integer = -16                     'Excel�Ŗ��O��`��������Ȃ�
Public Const errcxlDataNothing              As Integer = -32                     'Excel�Ńf�[�^Nothing
Public Const errcOthers                     As Integer = -16384                  '���̑��G���[
'�@������i�[����\����
Public Type typKishuInfo
    KishuHeader As String
    KishuName As String
    KishuNickName As String
    TotalRirekiketa As Byte
    RenbanKetasuu As Byte
    MaiPerSheet As Byte
    SheetPerRack As Byte
    BarcordReadNumber As Byte
End Type
Public Type typQRDataField
    JobNumber As String
    Zuban As String
    Maisuu As Integer
End Type
Public arrKishuInfoGlobal() As typKishuInfo
'QR�ǂ񂾂炮��΂��ϐ��ŕێ����Ă�̂ŁA�����ɓ��͂��Ă��(�t�H�[���Ԃ̃f�[�^�󂯓n���ɂȂ邽�߁j
Public QRField As typQRDataField
'���񂷁[�Ƃ��鎞�̃t�B�[���h��`�����������Ńn�[�h�R�[�f�B���O�����Ⴄ�E�E�E
'�e�[�u���������邽�тɋL�q���邱�ƁE�E�E
'�ǂ����z��͒萔�ɏo���Ȃ��悤�Ȃ̂ŁASQLBuilder�̃R���X�g���N�^���ŏ���������
Public arrFieldList_JobData() As String                                         'JobData�e�[�u���̃t�B�[���h��`
Public arrFieldList_Barcode() As String                                         'Barcode�e�[�u���̃t�B�[���h��`
Public arrFieldList_Retry() As String                                           'Retry�e�[�u���̃t�B�[���h��`
Public strRegistRireki As String                                                '�@��o�^�������A�t�H�[���Ԃ̎󂯓n���Ɏg��
'Public strQRZuban As String                                                     '�w����QR�R�[�h�ǂݎ�莞�̐}�Ԋi�[�A��ɋ@��o�^�Ŏg��
Public boolRegistOK As Boolean                                                  '�@��o�^������������True�t���O�𗧂Ă�
Public boolNoTableKishuRecord As Boolean                                        '�@��e�[�u���Ƀf�[�^�����݂��Ȃ��ꍇTrue�A�����̂�
'-------���X�g�\���̂��߂̒萔��`
'MS �S�V�b�N�i�����j�����T�C�Y9pt�̏ꍇ
Public Const sglChrLengthToPoint = 3.3
Public Const longMinimulPpiont = 50
'------------------------------------��������JSON�̃^�[��---------------------------------
'�eJson�t�@�C���ɂ́AName �L�[���K�{�A���̖��O��DB��Name�ɓo�^�����
Public Const JSON_File_InitialDB                As String = "InitialTable.json"     '�����e�[�u�����i�[JSON
Public Const JSON_TableSetting_NextTableName    As String = "TableSetting"          'JSON�ŁA�e�[�u����`�̃��[�g�v�f�AJSON�e�[�u����Name�ɓ���
Public Const JSON_Table_SQL                     As String = "SQL"                   '�e�[�u���쐬���̏���SQL��SQL�����̂܂ܓ���Ă��
Public Const JSON_Table_Description             As String = "Description"           '�e�[�u���̐����i��Łj
Public Const JSON_AppendField                   As String = "AppendField"           '�ǉ��t�B�[���h��`�J�n�i�܂�Dictionary�j
Public Const JSON_BarcordSheetSetting           As String = "BarcordeSheet"         'JSON �o�[�R�[�h�V�[�g��`���[�g�AJSON�e�[�u����Name�ɓ���
'-----------------------------------�Ŕ쐬�֌W------------------------------------------
Public Const Kanban_Json_Root                   As String = "KanbanTemplate"    '�Ŕe���v���[�g��JSON��Name�A���̖��O��JSON�e�[�u����Name�ɓ���
'Json�́A���[�g�iKanbanTempLate�j���Ƀe���v�����A���̉���Koutei1�A���̉���Koutei_No��Koutei_MeiMei
Public Const nameKanbanZuban                    As String = "Zuban"             '�Ŕ쐬�e���v���[�g�ɂ����Ă̐}�Ԗ��O��`
Public Const nameKanbanMaisuu                   As String = "KanbanMaisu"       '�Ŕ̖����A���̊ŔɎ��[����閇���AE74����68���Ƃ�
Public Const nameJobNumber                      As String = "KanbanJobNumber"   '�Ŕ�Job�ԍ�
Public Const nameRackNumber                     As String = "RackNumber"        '�Ŕ̃��b�N���A���݃��b�N��/���v���b�N��
Public Const nameJobMaisuu                      As String = "JobMaisuu"         '�Ŕ�Job�̍��v����
Public Const nameFromRireki                     As String = "FromRireki"        '�o�[�R�[�h�p�̊J�n����
Public Const nameToRireki                       As String = "ToRireki"          '�o�[�R�[�h�p�̏I������
Public Const nameQRQty                          As String = "QRQty"             'QR�R�[�h�̊������A���܂œd��Ōv�Z���Ă����
Public Const nameRangeKouteiNo                  As String = "RangeKouteiNo"     '�H��No��Range�A�Z���������Ă�֌W��No�ƍH�����ƕʂɂ���
Public Const nameRangeKouteiName                As String = "RangeKouteiName"   '�H����Range
Public Const MIN_Kanban_ChrCode                 As Byte = 65                    '�Ŕ�����̕����R�[�h�̍ŏ��l�iA�j
Public Const MAX_Kanban_ChrCode                 As Byte = 90                    '�Ŕ�����̕����R�[�h�̍ő�l�iZ)
Public Const BarCodeHeight                      As Double = 39.75               '���� ���̂��o�[�R�[�h�R���g���[���̃T�C�Y�ς�����Ⴄ�̂ŁA�����ōĐݒ�E�E�E
Public Const BarCodeWidth                       As Double = 74.25               '��
Public Const BarcodeTop                         As Double = 64.5                '�㌴�_
Public Const BarcodeFromLeft                    As Double = 278.25              'From�����_
Public Const BarcodeToLeft                      As Double = 462                 'To�����_