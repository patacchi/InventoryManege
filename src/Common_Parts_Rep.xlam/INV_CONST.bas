Attribute VB_Name = "INV_CONST"
'''�݌ɊǗ��֌W�̒萔���`����
Option Explicit
'�݌ɏ��DB�Ɋւ���萔
Public Const INV_DB_FILENAME As String = "INV_Manege.accdb"                     '�݌ɏ���DB�t�@�C����
'���i�i��z�R�[�h�j�}�X�^�[�e�[�u���̒萔
Public Const T_INV_PARTS_MASTER As String = "T_INV_M_Parts"                     '��z�R�[�h�}�X�^�[�̃e�[�u����
Public Const F_INV_TEHAI_ID As String = "F_INV_Tehai_ID"                        '��z�R�[�h��ID�A�e�e�[�u���ɂ͂��̒l��ݒ肷��
Public Const F_INV_TEHAI_TEXT As String = "F_INV_Tehai_Code"                    '��z�R�[�h
Public Const F_INV_MANEGE_SECTON As String = "F_INV_Manege_Section"             '�Ǘ���
Public Const F_INV_SYSTEM_TANA_NO As String = "F_INV_System_Tana_No"            '�V�X�e�����̒I�ԍ�
Public Const F_INV_KISHU As String = "F_INV_Kishu"                              '�@�햼
Public Const F_INV_STORE_CODE As String = "F_INV_Store_Code"                    '�����L��
Public Const F_INV_DELIVER_LOT As String = "F_INV_Deliver_Lot"                  '�����o�����b�g
Public Const F_INV_FILL_LOT As String = "F_INV_Fill_Lot"                        '��[���b�g
Public Const F_INV_LEAD_TIME As String = "F_INV_Lead_Time"                      '���[�h�^�C��
Public Const F_INV_ORDER_AMOUNT As String = "F_INV_Order_Amount"                '������
Public Const F_INV_ORDER_REMAIN As String = "F_INV_Order_Remain"                '�����c��
Public Const F_INV_STOCK_AMOUNT As String = "F_INV_Stock_Amount"                '�݌ɐ�
Public Const F_INV_TANA_ID As String = "F_INV_Tana_ID"                          '�I�ԍ���ID�A���Ԃ͒I�ԃ}�X�^�[����������邱��
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
'�I�Ԃ݂̂͋��L�ł��Ȃ��̂ŁA�Ǝ��ɐ������~��
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
    F_Order_Remail_ShZ = Enum_INV_M_Parts.F_Order_Remain_IMPrt
    F_Stock_Amount_ShZ = Enum_INV_M_Parts.F_Stock_Amount_IMPrt
    F_System_Name_ShZ = Enum_INV_M_Parts.F_System_Name_IMPrt
    F_System_Spec_ShZ = Enum_INV_M_Parts.F_System_Spec_IMPrt
    F_Store_Unit_ShZ = Enum_INV_M_Parts.F_Store_Unit_IMPrt
    F_System_Description_ShZ = Enum_INV_M_Parts.F_System_Description_IMPrt
    F_Manege_Section_Sub_ShZ = Enum_INV_M_Parts.F_Manege_Section_Sub_IMPrt
    '�I�ԃe�L�X�g�݂̂�����œƎ��ɐݒ肷��
    F_Tana_Text_ShZ = 101
End Enum