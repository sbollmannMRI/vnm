# Virtual Neuro Machine
![VNM Logo](virtualneuromachine_logo_small.png)


## Quickstart
1. Install Docker from here: https://docs.docker.com/get-docker/ (Mac, Windows, Linux)

2. Open a terminal, and type the folowing command to automatically download vnm and run it: 
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -p 6080:80 vnmd/vnm:latest
```

3. Open a browser and go to:
```
http://localhost:6080
```

## how to build:
```
docker build -t vnm:latest .
```

## Use in Mac
how to start local:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v /path/to/persistent:/vnm -p 6080:80 vnm:latest
open in browser: http://localhost:6080
```

how to start with custom screen resolution for VNC Viewer:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v /path/to/persistent:/vnm -e RESOLUTION=1920x980 -p 6080:80 -p 5900:5900 vnm:latest 
open in VNC viewer:  http://localhost:5900
```

how to stop:
```
docker stop vnm
docker rm vnm
```


## Use in Windows
create folder C:/vnm

how to start local:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -p 6080:80 vnm:latest
open in browser: http://localhost:6080
```

how to start with custom screen resolution for VNC Viewer:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -e RESOLUTION=1920x980 -p 6080:80 -p 5900:5900 vnm:latest 
open in VNC viewer:  http://localhost:5900
```

how to stop:
```
docker stop vnm; docker rm vnm
```


## Use in Linux
how to start local:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v /path/to/persistent:/vnm -p 6080:80 vnm:latest
open in browser: http://localhost:6080
```

how to start with custom screen resolution for VNC Viewer:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v /path/to/persistent:/vnm -e RESOLUTION=1920x980 -p 6080:80 -p 5900:5900 vnm:latest 
open in VNC viewer:  http://localhost:5900
```

how to stop:
```
docker stop vnm
docker rm vnm
```


## architecture layers
- vnm: docker container with singularity and all modifications of application menu based on  https://github.com/fcwu/docker-ubuntu-vnc-desktop developed here https://github.com/NeuroDesk/vnm
- neurodesk: bash script to install and manage multiple containers using transparent singularity on any linux system - developed here https://github.com/NeuroDesk/neurodesk
- transparent-singularity: script to install neuro-sub-containers, installers are called by neurodesk script https://github.com/NeuroDesk/transparent-singularity
- caid: build scripts for neuro-sub-containers, including testing of containers https://github.com/NeuroDesk/caid
- neuro-docker: provides recipes for containers build using caid https://github.com/NeuroDesk/neurodocker
