Attribute VB_Name = "PublicConst"
Option Explicit
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
'�e�e�[�u���ɂ�Default�Ƃ���InputDate������
Public Const INPUT_DATE As String = "InputDate"
'-------���X�g�\���̂��߂̒萔��`
'MS �S�V�b�N�i�����j�����T�C�Y9pt�̏ꍇ
Public Const sglChrLengthToPoint = 4.1
Public Const longMINIMULPOINT = 50