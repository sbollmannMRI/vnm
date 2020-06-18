## Virtual Neuro Machine

how to build:
```
docker build -t vnm:latest . 
```

how to start local:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -p 6080:80 vnm:latest 
open in browser: http://localhost:6080
```

how to start with custom screen resolution for VNC Viewer:
```
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -e RESOLUTION=1920x980 -p 6080:80 -p 5900:5900 vnm:latest 
open in VNC viewer:  http://localhost:5900
```

how to stop:
```
docker stop vnm
docker rm vnm

# or in windows powershell
docker stop vnm; docker rm vnm
```

project pitch:
https://docs.google.com/presentation/d/12wGoM9BSEn01i0yvtOq6HF8Q_jvKx8vvzonsY-lbEYA/edit#slide=id.p1

architecture layers
- vnm: docker container with singularity and all modifications of application menu based on  https://github.com/fcwu/docker-ubuntu-vnc-desktop developed here https://github.com/NeuroDesk/vnm 
- transparent-singularity: scripts to install neuro-sub-containers, installers are called by application menu entries https://github.com/NeuroDesk/transparent-singularity
- caid: build scripts for neuro-sub-containers, including testing of containers https://github.com/NeuroDesk/caid
- neuro-docker: provides recipes for containers https://github.com/NeuroDesk/neurodocker
