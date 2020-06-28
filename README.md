# Virtual Neuro Machine
![VNM Logo](virtualneuromachine_logo_small.png)

A compact Docker container with a browser-accessible environment for reproducible neuroimaging analysis. Only the required software packages are downloaded from a public library (as Singularity containers). Please complete the form to help guiding future additions to the software library: <iframe src="https://docs.google.com/forms/d/e/1FAIpQLSexZJrS5GPB-bO_9x58gESEbxYI8TNERETzAaLxFCGdF9XWwQ/viewform?embedded=true" width="700" height="520" frameborder="0" marginheight="0" marginwidth="0">Loading…</iframe> 

## Quickstart
1. Install Docker from here: https://docs.docker.com/get-docker/ (Mac, Windows, Linux; for HPC/supercomputer, please contact orenciv@gmail.com)

2. Open a terminal, and type the folowing command to automatically download vnm and run it:

Create a local folder that saves your downloaded applications, e.g. vnm in your home directory or in Windows on C:\

Mac:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v ~/vnm:/vnm -p 6080:80 vnmd/vnm:latest
```
Windows:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -p 6080:80 vnmd/vnm:latest
```
Linux:
```
sudo docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v ~/vnm:/vnm -p 6080:80 vnmd/vnm:latest
```

3. Open a browser and go to:
```
http://localhost:6080
```

4. how to stop container:
```
docker stop vnm
```

5. how to delete container:
```
docker rm vnm
```

## start with custom screen resolution for VNC Viewer:
add the following parameter to the docker call:
```
-e RESOLUTION=1920x980
open in VNC viewer:  http://localhost:5900
```


## Desktop modifications
* window tiling is set to: SHIFT-ALT-CTRL-{left,right,up,down}
