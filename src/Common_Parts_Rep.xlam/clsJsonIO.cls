VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsJsonIO"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
''' JSON�t�@�C���̓ǂݍ��݁A�������ݓ��������N���X
''' �t�@�C�������w��̏ꍇ�́ADEFAULT_JSON_FILENAME�萔�Ɏw�肵���t�@�C�����Ƃ���(General.json)
Option Explicit
'''--------------------------------------------------------------------------------------------------------------
'''�萔��`
Private Const DEFAULT_JSON_FILENAME As String = "INVGeneral.json"                           '�t�@�C�����̃f�t�H���g�A�S�ʐݒ�Json
Private Const DEFAULT_JSON_FILEDIRECTORY As String = "SettingJson"                          '�ݒ�t�@�C����u���f�t�H���g�̃f�B���N�g���ACommon_Parts�̃J�����g�f�B���N�g���̉��ɍ쐬
Private Const KEY_INV_CONST As String = "INV_CONST"                                         'INV�萔�ŏ�ʊK�w�̃L�[��
'�e�[�u�����ʂ̃L�[ �萔
Private Const KEY_TYPTABLECOMMON As String = "typTableCommon"                               '�e�e�[�u�����ʍ��ڂ̍ŏ�ʃL�[
Private Const KEY_TABLECOMMON_INPUTDATE As String = "F_InputDate"                           '���͓��� yyyy/mm/ddTHH:MM:SS.SSS �̋���23��
'���i�i��z�R�[�h�j�}�X�^�[�e�[�u���̃L�[ �萔
Private Const KEY_TYPPARTSMASTER As String = "typPartsMaster"                               '�p�[�c�}�X�^�[ �ŏ�ʃL�[��
Private Const KEY_PARTS_MASTER_TABLENAME As String = "T_INV_M_Parts"                        '��z�R�[�h�}�X�^�[�̃e�[�u����
Private Const KEY_INV_TEHAI_ID As String = "F_INV_Tehai_ID"                                 '��z�R�[�h��ID�A�e�e�[�u���ɂ͂��̒l��ݒ肷��
Private Const KEY_INV_TEHAI_CODE As String = "F_INV_Tehai_Code"                             '��z�R�[�h
Private Const KEY_INV_MANEGE_SECTON As String = "F_INV_Manege_Section"                      '�Ǘ���
Private Const KEY_INV_SYSTEM_LOCATION_NO As String = "F_INV_System_Location_No"             '�V�X�e�����̒I�ԍ�
Private Const KEY_INV_KISHU As String = "F_INV_Kishu"                                       '�@�� J7 �Ƃ� JL �Ƃ�
Private Const KEY_INV_STORE_CODE As String = "F_INV_Store_Code"                             '�����L�� FA,BS,BL
Private Const KEY_INV_DELIVER_LOT As String = "F_INV_Deliver_Lot"                           '�����o�����b�g
Private Const KEY_INV_FILL_LOT As String = "F_INV_Fill_Lot"                                 '��[���b�g
Private Const KEY_INV_LEAD_TIME As String = "F_INV_Lead_Time"                               '���[�h�^�C��
Private Const KEY_INV_ORDER_AMOUNT As String = "F_INV_Order_Amount"                         '������
Private Const KEY_INV_ORDER_REMAIN As String = "F_INV_Order_Remain"                         '�����c��
Private Const KEY_INV_STOCK_AMOUNT As String = "F_INV_Stock_Amount"                         '�݌ɐ�
Private Const KEY_INV_TANA_ID As String = "F_INV_Tana_ID"                                   '�I�ԃ}�X�^�[��ID�A���ۂ̓��e�͒I�}�X�^�[�e�[�u���Œ�`����
Private Const KEY_INV_SYSTEM_NAME As String = "F_INV_System_Name"                           '�V�X�e�����̕i���ACASE�Ƃ�
Private Const KEY_INV_SYSTEM_SPEC As String = "F_INV_System_Spec"                           '�V�X�e�����̌^�i�AIMONO�Ƃ�
Private Const KEY_INV_STORE_UNIT As String = "F_INV_Sotre_Unit"                             '�����P�ʁ@P�Ƃ�SET�Ƃ���
Private Const KEY_INV_SYSTEM_DESCRIPTION As String = "F_INV_System_Description"             '�V�X�e�����̎��R�L�q��
Private Const KEY_INV_LOCAL_DESCRIPTION As String = "F_INV_Local_Description"               '4701�Ǝ��̏ڍׂ��L�q�������ꍇ�Ɏg�p����
Private Const KEY_INV_MANEGE_SECTION_SUB As String = "F_INV_Manege_Section_Sub"             '�V�X�e�����̊Ǘ��ۃT�u
Private Const KEY_INV_LABEL_NAME_1 As String = "F_INV_Label_Name_1"                         'BIN�J�[�h���x���̕i��1�s�� CASE
Private Const KEY_INV_LABEL_NAME_2 As String = "F_INV_Label_Name_2"                         'BIN�J�[�h���x���̕i��2�s�ځA�s���̏��Ȃ����̂̕i���͂��̃t�B�[���h�̒l���g�� LF470�R�A
Private Const KEY_INV_LABEL_REMARK_1 As String = "F_INV_Label_Remark_1"                     'BIN�J�[�h���x���̔��l1�s�� �K�т₷���̂Œ���
Private Const KEY_INV_LABEL_REMARK_2 As String = "F_INV_Label_Remark_2"                     'BIN�J�[�h���x���̔��l2�s�� �ۊǂ̍ۊ����܂��p�E�`�t���܂ɓ��鎖
'�I�ԃ}�X�^�[
Private Const KEY_TYPTANAMASTER As String = "typTanaMaster"                                 '�I�ԃ}�X�^�[�̍ŏ�ʃL�[��
Private Const KEY_TANA_MASTER_TABLENAME As String = "T_INV_M_Tana"                          '�I�ԃ}�X�^�[�̃e�[�u����
Private Const KEY_INV_TANA_LOCAL_TEXT As String = "F_INV_Tana_Local_Text"                   '�\���p�Ȃǃ��[�J���Ŏg�p����I�Ԗ� K05G B01
Private Const KEY_INV_TANA_SYSTEM_TEXT As String = "F_INV_Tana_System_Text"                 '�V�X�e�����̒I��
'���x���o�͊֌W�L�[ �萔
Private Const KEY_TYPLABEL = "typLabelSetting"                                              '���x���֌W�萔�ŏ�ʃL�[��
Private Const KEY_INV_LABELTEMPTABLE_NAME As String = "LabelTempTableName"                  '���x���ꎞ�e�[�u�� �e�[�u����
Private Const KEY_INV_FORMSTARTTIME As String = "F_FormStartTime"                           '�t�H�[���X�^�[�g�^�C��
Private Const KEY_INV_FORMSTARTTIME_FRENDRY As String = "F_FormStartTime_FriendryName"      '�t�H�[���X�^�[�g���� �t�����h���[�l�[��
Private Const KEY_INV_INPUTDATE_FRENDRY As String = "F_InputDate_FriendryName"              '���͓����t�����h���[�l�[��
Private Const KEY_INV_ORDERNUM As String = "F_OrderNumber"                                  '�I�[�_�[No
Private Const KEY_INV_SAVEPOINT_FRENDTY As String = "F_SavePoint_FriendryName"              'SavePoint�t�����h���[�l�[��
Private Const KEY_INV_SAVEPOINT As String = "F_SavePoint"                                   'SavePoint
Private Const KEY_INV_TEHAICODE_LENGTH As String = "F_Tehaicode_Length"                     '��z�R�[�h������
'�݌ɏ��V�[�g�Ɋւ���萔
'Excel�t�@�C�����͓��t���V���A���l�Ƃ����������t������̂ŁA����ϓ�����
Private Const KEY_TYPSHZAIKO As String = "typSHZaiko"                                       '�݌ɏ��V�[�g�̍ŏ�ʃL�[��
Private Const KEY_INV_SH_ZAIKO_SHETNAME As String = "�݌ɏ��"                              '�݌Ɍ����Ń_�E�����[�h�ł���Excel�t�@�C���̍݌ɏ��V�[�g��
Private Const KEY_INV_SH_ZAIKO_TEHAI_CODE As String = "��z�R�[�h"                          '��z�R�[�h
Private Const KEY_INV_SH_ZAIKO_MANEGE_SECTON As String = "�Ǘ��ۋL��"                       '�Ǘ���
Private Const KEY_INV_SH_ZAIKO_SYSTEM_TANA_NO As String = "�I��"                            '�V�X�e�����̒I�ԍ�
Private Const KEY_INV_SH_ZAIKO_KISHU As String = "��z�@��"                                 '�@�햼
Private Const KEY_INV_SH_ZAIKO_STORE_CODE As String = "�����L��"                            '�����L��
Private Const KEY_INV_SH_ZAIKO_DELIVER_LOT As String = "���o���b�g"                         '�����o�����b�g
Private Const KEY_INV_SH_ZAIKO_FILL_LOT As String = "��[�_����"                            '��[���b�g
Private Const KEY_INV_SH_ZAIKO_LEAD_TIME As String = "���[�h�^�C��"                         '���[�h�^�C��
Private Const KEY_INV_SH_ZAIKO_ORDER_AMOUNT As String = "������"                            '������
Private Const KEY_INV_SH_ZAIKO_ORDER_REMAIN As String = "�����c"                            '�����c��
Private Const KEY_INV_SH_ZAIKO_STOCK_AMOUNT As String = "�݌ɐ���"                          '�݌ɐ�
Private Const KEY_INV_SH_ZAIKO_SYSTEM_NAME As String = "�i���L��"                           '�V�X�e�����̕i���ACASE�Ƃ�
Private Const KEY_INV_SH_ZAIKO_SYSTEM_SPEC As String = "�^�i�L��"                           '�V�X�e�����̌^�i�AIMONO�Ƃ�
Private Const KEY_INV_SH_ZAIKO_STORE_UNIT As String = "�P��"                                '�����P�ʁ@P�Ƃ�SET�Ƃ���
Private Const KEY_INV_SH_ZAIKO_SYSTEM_DESCRIPTION As String = "�݌Ɏ��R�L�q"                '�V�X�e�����̎��R�L�q��
Private Const KEY_INV_SH_ZAIKO_MANEGE_SECTION_SUB As String = "�Ǘ��ۃT�u"                  '�V�X�e�����̊Ǘ��ۃT�u
Private Const KEY_INV_SH_ZAIKO_TANA_TEXT As String = "���P�[�V����"                         '�I�ԍ����O�ADB�ɂ͒I�}�X�^�[�e�[�u���������������ID���Z�b�g����
'�I��CSV�Ɋւ���萔
Private Const KEY_TYPCSVTANA As String = "typCSVTana"                                       '�I��CSV�̍ŏ�ʃL�[
Private Const KEY_INV_CSV_TANA_TABLENAME As String = "T_INV_CSV"                            '�I��CSV�t�@�C�����i�[����e�[�u����
Private Const KEY_INV_CSV_TANA_ID As String = "F_CSV_ID"                                    'CSV�t�@�C����ID(�d���L��A���̂܂܂ł͎g�p�ł��Ȃ�)
Private Const KEY_INV_CSV_TANA_ENDDAY As String = "�I�����ؓ�"
Private Const KEY_INV_CSV_TANA_NO As String = "�m�n�D"
'Private Const KEY_INV_CSV_TANA_MANEGE_SECTION = KEY_INV_SH_ZAIKO_MANEGE_SECTON              '�l�������萔��`�͕s�v(�\���̂ŋ��L�w�肷��Ηǂ�����)
Private Const KEY_INV_CSV_TANA_MANEGE_SECTION_SUB = "�T�u�R�[�h"
'Private Const KEY_INV_CSV_TANA_TEHAI_CODE = KEY_INV_SH_ZAIKO_TEHAI_CODE                     '�l�������萔��`�̕ʖ��͕s�v
Private Const KEY_INV_CSV_TANA_SYSTEM_NAME As String = "�i��"
Private Const KEY_INV_CSV_TANA_SYSTEM_SPEC As String = "�^�i"
'private Const KEY_INV_CSV_TANA_SYSTEM_TANA_NO = F_SH_ZAIKO_SYSTEM_TANA_NO                   '�l�������萔��`�̕ʖ��͕s�v
'private Const KEY_INV_CSV_TANA_LOCATION_TEXT = F_SH_ZAIKO_TANA_TEXT                         '�l�������萔��`�̕ʖ��͕s�v
'Private Const KEY_INV_CSV_TANA_STORE_CODE = F_SH_ZAIKO_STORE_CODE                           '�l�������萔��`�̕ʖ��͕s�v
Private Const KEY_INV_CSV_TANA_STOCK_AMOUNT As String = "�݌ɐ�"
Private Const KEY_INV_CSV_TANA_AVAILABLE_AMOUNT As String = "���i�c"
Private Const KEY_INV_CSV_TANA_STATUS As String = "F_CSV_Status"                            '�`�F�b�N��ԃt���O���Ǘ�����Long�A�Ǝ��t�B�[���h
Private Const KEY_INV_CSV_TANA_BIN_AMOUNT As String = "F_CSV_BIN_Amount"                    'BIN�J�[�h�c�����L�^����t�B�[���h�A�Ǝ��t�B�[���h
'''--------------------------------------------------------------------------------------------------------------
'''�����o�ϐ���`
Private strFilePath As String                                       '�t�@�C���p�X���i�[���郁���o�ϐ�
Private fsoJsonFile As FileSystemObject                             'Json�t�@�C���̃t�@�C���V�X�e���I�u�W�F�N�g
Private typLabelSetting_ As typLabelSetting                         '����o�͂Ɋւ���萔��`�̍\����
Private dicJsonParsed As Dictionary                                 'Json�t�@�C�����p�[�X�V�e���ʂ��i�[�����Dictionary
'''--------------------------------------------------------------------------------------------------------------
'''�v���p�e�B��`
''' Autthor Daisuke Oota 2023_03_23
''' JSON�t�@�C���t���p�X���擾�E�ݒ肷��v���p�e�B
''' Filepath�擾
''' ����
'Property Get FilePath(Optional IsReload As Boolean = False) As String
Property Get FilePath() As String
    If strFilePath = "" Then
        '�����o�ϐ��̃t�@�C���p�X���󂾂�����W���ݒ��K�p����
        Dim fsoDefaultFilepath As FileSystemObject
        Set fsoDefaultFilepath = New FileSystemObject
        strFilePath = fsoDefaultFilepath.BuildPath(Application.ThisWorkbook.Path & "\" & DEFAULT_JSON_FILEDIRECTORY, DEFAULT_JSON_FILENAME)
        FilePath = strFilePath
        Exit Property
    Else
        FilePath = strFilePath
        Exit Property
    End If
End Property
''' FilePath �ݒ�
Property Let FilePath(strargFilePath As String)
    If strargFilePath = "" Then
        '�󂾂����甲����
        DebugMsgWithTime "Property Let FilePath:Arg is Empty"
        Exit Property
    End If
    strFilePath = strargFilePath
End Property
''' LabelSetting�\����
Property Get LabelSetting() As typLabelSetting
    '�t�@�C�����烁���o�ϐ���Dictionary�Ƀp�[�X�������ʂ��Z�b�g����
    On Error GoTo ErrorCatch
    Call SetJsonDicbyFileName
    '�\���̂̃����o�[�ɒl���Z�b�g���Ă���
    typLabelSetting_.F_FormStartTime_FriendryName = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_FORMSTARTTIME_FRENDRY)
    typLabelSetting_.F_InputDate_FriendryName = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_INPUTDATE_FRENDRY)
    typLabelSetting_.F_OrderNumber = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_ORDERNUM)
    typLabelSetting_.F_FormStartTime = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_FORMSTARTTIME)
    typLabelSetting_.F_SavePoint_FriendryName = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_SAVEPOINT_FRENDTY)
    typLabelSetting_.F_SavePoint = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_SAVEPOINT)
    typLabelSetting_.F_Tehaicode_Length = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_TEHAICODE_LENGTH)
    typLabelSetting_.LabelTempTableName = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_LABELTEMPTABLE_NAME)
    typLabelSetting_.F_INV_Tana_Local_Text = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_TANA_LOCAL_TEXT)
    typLabelSetting_.F_INV_Tehai_Code = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_TEHAI_CODE)
    typLabelSetting_.F_INV_Store_Code = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_STORE_CODE)
    typLabelSetting_.F_INV_Kishu = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_KISHU)
    typLabelSetting_.F_INV_Label_Name_1 = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_LABEL_NAME_1)
    typLabelSetting_.F_INV_Label_Name_2 = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_LABEL_NAME_2)
    typLabelSetting_.F_INV_Label_Remark_1 = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_LABEL_REMARK_1)
    typLabelSetting_.F_INV_Label_Remark_2 = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_INV_LABEL_REMARK_2)
    typLabelSetting_.F_InputDate = dicJsonParsed(KEY_INV_CONST)(KEY_TYPLABEL)(KEY_TABLECOMMON_INPUTDATE)
    '�擾�������ʂ�Ԃ�
    LabelSetting = typLabelSetting_
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "LabelSetting code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
    Exit Property
CloseAndExit:
    Exit Property
End Property
'''--------------------------------------------------------------------------------------------------------------
''' �v���V�[�W����`
''' �w�肵���t�@�C���p�X�̃t�@�C�����p�[�X���A�����o�ϐ���Dictionary�ɃZ�b�g����
Private Sub SetJsonDicbyFileName(Optional strargFilePath As String)
    On Error GoTo ErrorCatch
    Dim strTargetFilePath As String
    If strargFilePath = "" Then
        '�����Ńt�@�C���p�X���w�肳��Ȃ������ꍇ
        '�v���p�e�B�����������
        strTargetFilePath = Me.FilePath
    Else
        '�����Ŏw�肳�ꂽ�ꍇ�͂��̒l���Z�b�g����
        strTargetFilePath = strargFilePath
    End If
    If fsoJsonFile Is Nothing Then
        '�����o�ϐ�������������Ă��Ȃ������炱���ŏ�����
        Set fsoJsonFile = New FileSystemObject
    End If
    If Not fsoJsonFile.FileExists(strTargetFilePath) Then
        '�t�@�C����������Ȃ������ꍇ
        DebugMsgWithTime "SetJsonDicbyFileName: File Not found"
        GoTo CloseAndExit
        Exit Sub
    End If
    Dim adoStream As ADODB.Stream
'    Set tsJsonFile = fsoJsonFile.OpenTextFile(strTargetFilePath, ForReading, False, TristateFalse)
    Set adoStream = New ADODB.Stream
    'adoStream�̃I�v�V�������Z�b�g���Ă���
    'FileSystemObject��OpenText���\�b�h����UTF-8�t�@�C������肭�����Ȃ��̂ŁAADODB.STREAM�ɂď�������
    adoStream.Charset = "UTF-8"
    adoStream.Open
    adoStream.LoadFromFile strTargetFilePath
    'Stream�̌��ʂ��e�L�X�g�Ƃ��ēǂݍ���
    Dim strJsonRaw As String
    strJsonRaw = adoStream.ReadText
    adoStream.Close
    '�e�L�X�g����p�[�X�������ʂ������o�ϐ���Dictionary�ɃZ�b�g����
    Set dicJsonParsed = JsonConverter.ParseJson(strJsonRaw)
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "SetJsonDicbyFileName code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
    Exit Sub
CloseAndExit:
    If Not adoStream Is Nothing Then
        If adoStream.State And adStateOpen Then
            '�ڑ����ĂĂ���悤�Ȃ�Close����
            adoStream.Close
        End If
    End If
    Exit Sub
End Sub