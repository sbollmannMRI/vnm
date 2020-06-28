# Virtual Neuro Machine
![VNM Logo](virtualneuromachine_logo_small.png)

A compact Docker container with a browser-accessible environment for reproducible neuroimaging analysis. Only the required software packages are downloaded already pre-installed from a public library (as Singularity containers). Please complete the survey to help guiding future additions to the software library: https://forms.gle/deKy85yniJLP4hDM8


## Quickstart
1. Install Docker from here: https://docs.docker.com/get-docker/ (Mac, Windows, Linux; for HPC/supercomputer, please contact orenciv@gmail.com)

2. Create a local folder where the downloaded software packages will be stored, e.g. ~/vnm in Mac and Linux, or C:\vnm in Windows 

3. Open a terminal, and type the folowing command to automatically download the vnm container and run it:

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

4. Open a browser and go to:
```
http://localhost:6080
```

5. Stop the vnm container by typing:
```
docker stop vnm
```

6. Delete the vnm container by typing:
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
