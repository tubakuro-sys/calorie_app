@echo off
chcp 65001 > nul
setlocal

echo ============================================
echo  リリーススクリプト - 更新用
echo ============================================
echo.

:: カレントディレクトリ確認
for %%I in (.) do set APP_NAME=%%~nxI
echo アプリ名: %APP_NAME%
echo フォルダ: %CD%
echo.

:: gitリポジトリ確認
if not exist ".git" (
    echo [エラー] このフォルダはGitリポジトリではありません。
    echo         new_app.bat で初期化してください。
    pause
    exit /b 1
)

:: コミットメッセージ入力
set /p COMMIT_MSG="コミットメッセージを入力: "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=update

:: 変更確認
echo.
echo --- 変更ファイル確認 ---
git status --short
echo.

set /p CONFIRM="上記をpushしますか？ (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo キャンセルしました。
    pause
    exit /b 0
)

:: git操作
echo.
echo [1/3] git add ...
git add .

echo [2/3] git commit ...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo [情報] コミットする変更がありません。
    pause
    exit /b 0
)

echo [3/3] git push ...
git push origin main
if errorlevel 1 (
    echo [エラー] pushに失敗しました。
    pause
    exit /b 1
)

:: 完了
echo.
echo ============================================
echo  完了！数分後に以下のURLに反映されます
echo  https://tubakuro-sys.github.io/%APP_NAME%/
echo ============================================
echo.
pause
