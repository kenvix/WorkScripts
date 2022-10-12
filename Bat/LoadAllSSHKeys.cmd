@echo off
SET SSHKeyDir=C:\Users\Kenvix\Documents\SSHKeys\!Autoload

cd /d %SSHKeyDir%
ssh-agent
forfiles /s /m * /c "cmd /c echo @path && ssh-add @path"
ssh-add -l