rem First check if the VNC standalone is installed

if exist 'C:\vnm\RealVNCStandalone.exe' (
    echo "VNC standalone exists"
) else (
    echo VNC doesn't exist, downloading now...
    $path = "C:\vnm"
    If(!(test-path $path))
    {
         New-Item -ItemType Directory -Force -Path $path
    }
    powershell -Command "Invoke-WebRequest https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.529-Windows-64bit.exe -OutFile 'C:\vnm\RealVNCStandalone.exe'"
)
rem "checking for docker, none of this works yet"
@echo off
if "Get-Process 'com.docker.proxy' &&  echo $? " == "False" ( 
 echo "--------------------------------------------------------------"
 ECHO "Please follow the instruction to download and install Docker:"
echo "---------------------------------------------------------------"
  start "www.hub.docker.com/editions/community/docker-ce-desktop-windows"
) else (
::"I don't like to think of PowerShell as "CMD with the stupid parts removed". I like to think of it as "Bash without any of the useful bits".
rem "build and start the docker image plus the VNC viewer"
docker build -t vnm:latest . && (
    ECHO "Starting VNM:"
    docker images
    REM docker run -d --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -p 6080:80 vnm:latest ## -p 6080:80
docker run -d --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -e RESOLUTION=1920x990 -p 5900:5900 vnm:latest  
echo "docker started, opening VNC session"
start 'C:\vnm\RealVNCStandalone.exe' localhost:5900 
    rem remove the last session
    set /p=VNM is running - press ENTER key to shutdown and quit VNM!
    docker stop vnm
    docker rm vnm
)) || (
    echo "-------------------------"
    echo "Docker Build failed!"
    echo "-------------------------"
)
)