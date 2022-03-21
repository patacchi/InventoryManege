// main.cpp
#include <windows.h>
#include <tchar.h>
#define ID_MYTIMER 100
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
ATOM InitApp(HINSTANCE);
BOOL InitInstance(HINSTANCE, int);
void MyDrawText(HWND, HDC,PAINTSTRUCT);

char szClassName[] = "sample02";	//�E�B���h�E�N���X

int WINAPI WinMain(HINSTANCE hCurInst, HINSTANCE hPrevInst, LPSTR lpsCmdLine, int nCmdShow) {
	MSG msg;
	BOOL bRet;

	if (!InitApp(hCurInst))
		return FALSE;
	if (!InitInstance(hCurInst, nCmdShow))
		return FALSE;

	while ((bRet = GetMessage(&msg, NULL, 0, 0)) != 0) {
		if (bRet == -1) {
			break;
		}
		else {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}
	return (int)msg.wParam;
}

ATOM InitApp(HINSTANCE hInst) {
	WNDCLASSEX wc;
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc = WndProc;	//�v���V�[�W����
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = hInst;//�C���X�^���X
	wc.hIcon = NULL; //�A�v���̃A�C�R���B.ico�t�@�C�������\�[�X�t�@�C���ɓǂݍ��݂����ɋL��
	wc.hCursor = (HCURSOR)LoadImage(NULL, MAKEINTRESOURCE(IDC_ARROW), IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_SHARED);
	//wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);//Window�̔w�i�F���w��B
	wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH); //���ߗp��Window�w�i�F��ݒ�
	wc.lpszMenuName = NULL;	 // ���j���[���B���\�[�X�t�@�C���Őݒ肵���l���L��
	wc.lpszClassName = (LPCSTR)szClassName;
	wc.hIconSm = NULL; //�A�v���̃A�C�R���̏������ŁB�^�X�N�o�[�ɕ\����������

	return (RegisterClassEx(&wc));
}


//�E�B���h�E�̐���
BOOL InitInstance(HINSTANCE hInst, int nCmdShow) {
	HWND hWnd;

	//hWnd = CreateWindow(szClassName,
	hWnd = CreateWindowEx(WS_EX_LAYERED, //�E�B���h�E�Ƀ��C���[�h�E�B���h�E�g��������t������
		szClassName,
		"Sample Application 1", //Window�̃^�C�g��
		WS_OVERLAPPEDWINDOW, //�E�B���h�E�̎��
		CW_USEDEFAULT,	//�w���W (�w��Ȃ���CW_USEDEFAULT)
		CW_USEDEFAULT,	//�x���W(�w��Ȃ���CW_USEDEFAULT)
		CW_USEDEFAULT,	//��(�w��Ȃ���CW_USEDEFAULT)
		CW_USEDEFAULT,	//����(�w��Ȃ���CW_USEDEFAULT)
		NULL, //�e�E�B���h�E�̃n���h���A�e�����Ƃ���NULL
		NULL, //���j���[�n���h���A�N���X���j���[���g���Ƃ���NULL
		hInst, //�C���X�^���X�n���h��
		NULL);

	if (!hWnd)
		return FALSE;
	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);
	return TRUE;
}


//�E�B���h�E�v���V�[�W��
//���[�U�[��Window�𑀍삵����AWindow�����ꂽ�肵���ꍇ�A���̊֐����Ăяo����ď������s���B
LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wp, LPARAM lp) {
	HBRUSH hBrush;
	HDC hdc, hdc_mem;
	PAINTSTRUCT ps;
	static HPEN hBigPen, hSmallPen;
	RECT rc;
	int id,w,h,i,recx,recy;
	static int x,y,wx, wy, r;
	char szBuf[32] = "�L�ł��킩��Layer";
	static BOOL bDec = FALSE;
	switch (msg) {
	case WM_CREATE:
		//CreateWindow()��Window���쐬�����Ƃ��ɌĂяo�����B�����ŃE�B�W�F�b�g���쐬����B
		/*
		BOOL SetLayeredWindowAttributes(
			HWND hwnd,           // �E�B���h�E�̃n���h��
			COLORREF crKey,      // COLORREF�l
			BYTE bAlpha,         // �A���t�@�̒l
			DWORD dwFlags        // �A�N�V�����t���O
		);
		hwnd�ɂ́A���C���[�E�B���h�E�̃n���h�����w�肵�܂��B
		crKey�ɂ́A�����ɂ���J���[�L�[��RGB�l���w�肵�܂��B
		bAlpha�ɂ́A�A���t�@�l���w�肵�܂��B0�őS���̓����A255�ŕs�����ƂȂ�܂��B
		dwFlags�ɂ́A���̒l�̂����ꂩ�A�܂��͗������w�肵�܂��B
		�l				�Ӗ�
		LWA_COLORKEY	crKey���L��
		LWA_ALPHA		bAlpha���L��
		���������0�ȊO�̒l���Ԃ�A���s�����0���Ԃ�܂��B
		*/
		hBigPen = CreatePen(PS_SOLID, 4, RGB(0, 0, 0));
		hSmallPen = CreatePen(PS_SOLID, 1, RGB(0, 0, 0));
		SetLayeredWindowAttributes(hWnd, RGB(255, 0, 0), 0,LWA_COLORKEY); //���ߐF�Ƃ��Đ�(255,0,0)���w��
		//�^�C�}�[����J�n
		//SetTimer(hWnd, ID_MYTIMER, 200, NULL);
		break;
	case WM_TIMER:
		//Timer�C�x���g
		if (wp != ID_MYTIMER) {
			return DefWindowProc(hWnd, msg, wp, lp);
		}
		if (bDec) {
			r -= 5;
			if (r <= 0) {
				bDec = FALSE;
			}
		}
		else {
			r += 5;
			if (r >= wy || r >= wx) {
				bDec = TRUE;
			}
		}
		InvalidateRect(hWnd, NULL, TRUE);	//����ɂ��WM_PAINT���b�Z�[�W���Ĕ��s�����
		break;
	case WM_DESTROY:
		//���[�U�[��Window�E��́~�{�^���������Ƃ��������s�����
		DeleteObject(hBigPen);
		DeleteObject(hSmallPen);
		KillTimer(hWnd, ID_MYTIMER);
		PostQuitMessage(0); //�I�����b�Z�[�W
		break;
	case WM_SIZE:
		//�T�C�Y�ύX���b�Z�[�W
		wx = LOWORD(lp);
		wy = HIWORD(lp);
		x = wx / 2;
		y = wy / 2;
		break;
	case WM_PAINT:
		//��ʂɐ}�`�Ȃǂ�`������������
		hdc = BeginPaint(hWnd, &ps);	//�f�o�C�X�R���e�L�X�g�擾
		hBrush = CreateSolidBrush(RGB(255, 0, 0));	//Brush�̃n���h���擾
		SelectObject(hdc, hBrush);	//�u���V�I�u�W�F�N�g��K�p
		/*
		BOOL ExtFloodFill(
		HDC hdc,          // �f�o�C�X�R���e�L�X�g�n���h��
		int nXStart,      // �J�n�_�� x ���W
		int nYStart,      // �J�n�_�� y ���W
		COLORREF crColor, // �F
		UINT fuFillType   // ���
		);
		���݂̃u���V���g���ēh��Ԃ��܂��B
		hdc�ɂ́A�f�o�C�X�R���e�L�X�g�n���h�����w�肵�܂��B
		nXStart, nYStart�ɂ́A�h��Ԃ��J�n�̍��W���w�肵�܂��B
		crColor�́ARGB�l���w�肵�܂����A���̈Ӗ���fuFillType�ɂ��قȂ�܂��B
		fuFillType�ɂ́A�h��Ԃ��̎�ނ��w�肵�܂��B���̂����ꂩ���w�肵�܂��B
		�l	�Ӗ�
		FLOODFILLBORDER	crColor�Ŏw�肵���F���͂�ł���̈���A�h��Ԃ��܂��B
		FLOODFILLSURFACE	crColor�Ŏw�肵���F�Ɠ����F�ɂȂ��Ă���̈���A�h��Ԃ��܂��B
		*/
		ExtFloodFill(hdc, 1, 1, RGB(255, 255, 255), FLOODFILLSURFACE);	//�ŏ��ɔ�(255,255,255)�œh��Ԃ��Ă��邽�߁A�������^�[�Q�b�g�ɂ���
		/*
		//�}�`�`�悵�Ă݂��Ղ̖�
		GetClientRect(hWnd, &rc);
		w = rc.right;
		h = rc.bottom;
		SelectObject(hdc, hBigPen);
		Rectangle(hdc, 30, 30, w - 30, h - 30);
		SelectObject(hdc, hSmallPen);
		for (i = 0;i < 10;i++) {
			recy = 30 + ((h - 60) / 10)*i;
			MoveToEx(hdc, 30, recy, NULL);
			LineTo(hdc, w - 30, recy);
			recx = 30 + ((w - 60) / 10)*i;
			MoveToEx(hdc, recx, 30, NULL);
			LineTo(hdc, recx, h - 30);
		}
		//�~��`��
		Ellipse(hdc, x - (r / 2), y - (r / 2), x + (r / 2), y + (r / 2));
		*/
		//�e�L�X�g�`�悵�Ă݂�
		//TextOut(hdc, 10, 90, szBuf, (int)strlen(szBuf));
		MyDrawText(hWnd, hdc,ps);
		DeleteObject(hBrush);
		EndPaint(hWnd, &ps);
		break;
	default:
		return (DefWindowProc(hWnd, msg, wp, lp));
	}
	return 0;
}
//�g���e�L�X�g�\���v���V�[�W��
//Return void
//args
//HWND hWnd		�E�B���h�E�̃C���X�^���X�n���h��
//HDC hdc		�f�o�C�X�R���e�L�X�g�̃n���h��
//PAINTSTRUCT ps	PAINTSTRUCT�\����
void MyDrawText(HWND hWnd, HDC hdc,PAINTSTRUCT ps) {
	char szSTR[]= _T("5P8A1314P003A");
	HFONT hFont1 = CreateFont();
	SelectObject(hdc, hFont1);
	TextOut(hdc, 10, 90, (LPCSTR)szSTR, (int)strlen(szSTR));
}