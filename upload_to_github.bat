@echo off
echo Initializing Git repository...
git init
git add .
git commit -m "Initial commit: Aegis Privacy Browser"
git branch -M main
echo Linking to remote repository...
git remote add origin https://github.com/danithu17/browser.git
echo Pushing to GitHub...
git push -u origin main
pause
