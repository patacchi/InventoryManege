Attribute VB_Name = "PublicConst"
Option Explicit
'Msforms��Mouse�C�x���g��Button�萔�l
Public Const vbMouseLeft As Integer = 1                         '���N���b�N���̃R�[�h
Public Const vbMouseRight As Integer = 2                        '�E�N���b�N���̃R�[�h
Public Const vbMouseMiddle As Integer = 4                       '�����{�^���N���b�N���̃R�[�h
'�f�[�^�x�[�X�S�ʂ̒萔��`
'DB�t�@�C���̊g���q
Public Const DB_FILE_EXETENSION_ACCDB As String = "accdb"       'DB�t�@�C���̊g���q���̂P(lcase�ɂ��āj
Public Const DB_FILE_EXETENSION_XLAM = "xlam"                   '�G�N�Z���A�h�I���t�@�C��
Public Const DB_FILE_EXETENSION_XLSM = "xlsm"                   '�G�N�Z���}�N���L���u�b�N
Public Const DB_FILE_EXETENSION_XLSX = "xlsx"                   '�G�N�Z��XLS�`���u�b�N
Public Const DB_FILE_EXETENSION_XLSB = "xlsb"                   '�G�N�Z���o�C�i���`���u�b�N
Public Const DB_FILE_EXETENSION_XLS = "xls"                     'Excel97�܂ł̃G�N�Z���u�b�N�`��
Public Const DB_FILE_EXETENSION_CSV = "csv"                     'CSV�t�@�C���`��
'DB�t�@�C���̗񋓑�
Public Enum DB_file_exetension
    accdb_dext = 1
    xlam_dext = 2
    xlsm_dext = 3
    xlsx_dext = 4
    xlsb_dext = 5
    xls_dext = 6
    csv_dext = 7
End Enum
'�t�B�[���h���o����������(SQL)
Public Const SQL_F_EQUAL As String = " = "                      'SQL��WHERE�������ȂǂŃt�B�[���h�Ԃ�A�����镶���� =
Public Const SQL_F_NOT_EQUAL As String = " <> "                 '<>
Public Const SQL_F_TRIM_PREFIX As String = "TRIM("              'TRIM$�g�����Ƀt�B�[���h�̑O�ɕt���v���t�B�b�N�X
Public Const SQL_ISNUMERIC_0FieldName As String = "IIF(ISNUMERIC({0}),CDBL({0}),0)"   '0�Ƀt�B�[���h��������A���l��Double�œ��͂���̂ŁA�^�ϊ�������A��������Ȃ��ƃf�[�^�^�G���[���o��
Public Const SQL_ISNULLTRIM_0FieldName As String = "IIF(ISNULL(TRIM({0})),"""",TRIM({0}))"          'Trim�̌��ʂ�Null�������ꍇ�͌Œ�̕����������
Public Const SQL_F_TRIM_SUFFIX As String = ")"                  'TRIM�g�p���̃T�t�B�b�N�X
Public Const SQL_F_CONNECT_OR As String = " OR "                '�������������ɂ����āA���̏����Ƃ̊Ԃɋ��ތ�� OR
Public Const SQL_F_CONNECT_AND As String = " AND "              'AND
Public Const SQL_F_CONNECT_COMMA As String = ","                ', ���ꂾ���͑O��ɃX�y�[�X����Ȃ������ǂ�
'���o����������Enum
Public Enum Enum_SQL_F_Condition
    Equal_sfc = 1
    NOT_Equal_sfc = 2
    Trim_Prefix_sfc = 3
    Trim_Suffix_sfc = 4
    Connect_OR_sfc = 5
    Connect_AND_sfc = 6
    Connect_Comma_sfc = 7
End Enum
'�e�e�[�u���ɂ�Default�Ƃ���InputDate������
Public Const INPUT_DATE As String = "F_InputDate"
'Temp�f�[�^�x�[�X�AExcel�t�@�C���͈ꎞ�e�[�u���Ɋi�[����������肭�����݂����Ȃ̂ŁA�Ƃ肠�����ꎞ�e�[�u���݂̂�u���f�[�^�x�[�X�t�@�C��
Public Const TEMP_DB_FILENAME As String = "DB_Temp_Local.accdb"       '�SDB����
'-------���X�g�\���̂��߂̒萔��`
'MS �S�V�b�N�i�����j�����T�C�Y9pt�̏ꍇ
Public Const sglChrLengthToPoint = 4.1
Public Const longMINIMULPOINT = 50