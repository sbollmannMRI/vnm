# Virtual Neuro Machine
![VNM Logo](virtualneuromachine_logo_small.png)


## Quickstart
1. Install Docker from here: https://docs.docker.com/get-docker/ (Mac, Windows, Linux; for HPC/supercomputer, please contact orenciv@gmail.com)

2. Open a terminal, and type the folowing command to automatically download vnm and run it: 
Mac\Windows:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -p 6080:80 vnmd/vnm:latest
```
Linux:
```
sudo docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -p 6080:80 vnmd/vnm:latest
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

## Desktop modifications
* window tiling is set to: SHIFT-ALT-CTRL-{left,right,up,down}
