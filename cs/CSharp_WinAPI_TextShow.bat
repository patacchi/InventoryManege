@echo off
rem �\�[�X�t�@�C���Ɠ����f�B���N�g���ɂ��̃o�b�`�t�@�C����z�u���Ă��������B
rem �o�b�`�t�@�C�������s����Ɠ����f�B���N�g���ɂ���\�[�X�t�@�C�����R���p�C������܂��B
rem �o�[�W���������͊e���ɒu�������ĉ������B
cd /d C:\Windows\Microsoft.NET\Framework\v4.0.30319

rem set srcPath=%~dp0*.cs %~dp0*.resx %~dp0Properties\*.cs %~dp0Properties\*.resx
set srcPath=%~dp0CSharp_WinAPI_TextShow\*.cs %~dp0CSharp_WinAPI_TextShow\Properties\*.cs
set exePath=%~dp0Bin\Debug\%~n0.exe

set dllPaths=system.dll,system.drawing.dll,system.windows.forms.dll

csc.exe /t:winexe /optimize+ /out:%exePath% %srcPath% /r:%dllPaths%

echo %ERRORLEVEL%

if %ERRORLEVEL% == 0 (
  goto SUCCESS
)

pause

:SUCCESS