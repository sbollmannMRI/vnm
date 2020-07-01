#First check if there is a VNC player installed
if "Get"

$path = "C:\vnm"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
powershell -Command "Invoke-WebRequest https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.529-Windows-64bit.exe -OutFile 'C:\vnm\RealVNCStandalone.exe'"
start 'C:\vnm\RealVNCStandalone.exe' -scale 79/100
@echo off
if "Get-Process 'com.docker.proxy' &&  echo $? " == "False" ( 
 echo "--------------------------------------------------------------"
 ECHO "Please follow the instruction to download and install Docker:"
echo "---------------------------------------------------------------"
  start "www.hub.docker.com/editions/community/docker-ce-desktop-windows"
) else (


 
docker build -t vnm:latest . && (
    ECHO "Starting VNM:"
    docker images
    REM docker run -d --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -p 6080:80 vnm:latest
    docker run -d --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -e RESOLUTION=1920x990 -p 6080:80 -p 5900:5900 vnm:latest
    set /p=VNM is running - press ENTER key to shutdown and quit VNM!
    docker stop vnm
    docker rm vnm
) || (
    echo "-------------------------"
    echo "Docker Build failed!"
    echo "-------------------------"
)
)