Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


choco install googlechrome -y
choco install vcredist140 -y
choco install visualcpp-build-tools -y
choco install python3 -y
choco install 7zip.install -y
choco install git.install -y
choco install notepadplusplus -y
choco install vscode -y
choco install wireshark -y
choco install procexp -y
choco install tcpview -y
choco install sigcheck -y
choco install systeminformer -y