Attribute VB_Name = "PublicConst"
Option Explicit
'�f�[�^�x�[�X�S�ʂ̒萔��`
'DB�t�@�C���̊g���q
Public Const DB_FILE_EXETENSION1 As String = "accdb"            'DB�t�@�C���̊g���q���̂P(lcase�ɂ��āj
'DB�t�@�C���̗񋓑�
Public Enum DB_file_exetension
    accdb_dext = 0
End Enum
''-------���X�g�\���̂��߂̒萔��`
''MS �S�V�b�N�i�����j�����T�C�Y9pt�̏ꍇ
'Public Const sglChrLengthToPoint = 4.1
'Public Const longMINIMULPOINT = 50
''�t�B�[���h�ǉ��pSQL��^��
'Public Const strOLDAddField1_NextTableName     As String = "ALTER TABLE """        '�ǉ��̍ŏ��A���̎��Ƀe�[�u����������
'Public Const strOLDAddField2_NextFieldName     As String = """ ADD COLUMN """      '��ԖځA���̎��Ƀt�B�[���h��������
'Public Const strOLDAddField3_Text_Last         As String = """ TEXT;"              '�Ō�A������TEXT�^�̏ꍇ
'Public Const strOLDAddField3_Numeric_Last      As String = """ NUMERIC;"           '���l�̏ꍇ�̍Ō�
'Public Const strOLDAddField3_JSON_Last         As String = """ JSON;"              'JSON���X�g
''�C���f�b�N�X�ǉ��pSQL��^��
'Public Const strOLDIndex1_NextTable            As String = "CREATE INDEX IF NOT EXISTS ""ixJob_"
'Public Const strOLDIndex2_NextTable            As String = """ ON """
'Public Const strOLDIndex3_Field1               As String = """ ("""
'Public Const strOLDIndex4_FieldNext            As String = """ ASC ,"""            '�����t�B�[���h�ɑ΂��Ď��s����ꍇ�́A�Ȍケ��̌J��Ԃ�
'Public Const strOLDIndex5_Last                 As String = """ ASC);"
''�e�[�u���ǉ��pSQL��^��
'Public Const strTable1_NextTable                As String = "CREATE TABLE IF NOT EXISTS " 'CRLF�t���A����уt�B�[���h����ǉ��Ή��e���v��
'Public Const strTable2_Next1stField             As String = " (" & vbCrLf           'CRLF�Ή��쐬�e���v���A��������g���ꍇ��AddQuote���g���ăG�X�P�[�v�������邱��
''�t�B�[���h��`�A�t�B�[���h���i�N�I�[�g�j��3(�^��)��[Append](�e�퐧��A�����)��(EndRow)���i���̃t�B�[���h������΁j�t�B�[���h���i�N�I�[�g�j���^���E�E�E�̗���
''1 �e�[�u���� 2 �ŏ��̃t�B�[���h 3�i�^��) �i��������Ȃ�j4 �t�B�[���h���E�E�E�@�i�Ō�Ȃ�j5
'Public Const strTable3_TEXT                     As String = " TEXT "                '�O��TEXT
'Public Const strTable3_NUMERIC                  As String = " NUMERIC "             '�O��NUMERIC
'Public Const strTable3_JSON                     As String = " JSON "                '�O��JSON
'Public Const strTable_NotNull                   As String = " NOT NULL "            'NOT NULL����ǉ�
'Public Const strTable_Unique                    As String = " UNIQUE "              'UNIQUE����ǉ�
'Public Const strTable_Default                   As String = " DEFAULT "             'DEFAULT�ǉ��A���̌�Ƀf�t�H���g�l���N�I�[�g�������Ēǉ����邱��
'Public Const strTable4_EndRow                   As String = "," & vbCrLf            '�s�̏I���A�܂�����������ꍇ
'Public Const strTable4_5_PrimaryKey             As String = "PRIMARY KEY("          'PrimaryKey�̎w������̌�ɑ�����
'Public Const strTable4_6_EndPrimary             As String = ")" & vbCrLf            'PrimaryKey���̃J�b�R��
'Public Const strTable5_EndSQL                   As String = ");" & vbCrLf           'SQL���̏I���
'Public Const strOLDAddTable1_NextTable          As String = "CREATE TABLE IF NOT EXISTS """ '�e�[�u���ǉ��p��^����������
'Public Const strOLDAddTable2_Field1_Next_Field  As String = """ ("""                '�t�B�[���h�̍ŏ������������g���A���ɍŏ��̃t�B�[���h��
'Public Const strOLDAddTable_TEXT_Next_Field     As String = """ TEXT,"""            '����킵�����ǁA�u�O�v��Text�^�̏ꍇ���������g���A���Ƀt�B�[���h��������
'Public Const strOLDAddTable_TEXT_UNIQUE_Next_Field As String = """ TEXT UNIQUE,"""  '�O��TEXT ���� UNIQUE�̏ꍇ
'Public Const strOLDAddTable_NUMELIC_Next_Field  As String = """ NUMERIC,"""         '�u�O�v��Numeric�̏ꍇ�͂�����
'Public Const strOLDAddTable_Text_Last           As String = """ TEXT);"             '�����h�E�Ȃ̂ŁA�Ō��Text�ŏI��点�āE�E�E
'Public Const strOLDAddTable_Numeric_Last        As String = """ NUMERIC);"          '�ꉞ���l�^�ŏI�����