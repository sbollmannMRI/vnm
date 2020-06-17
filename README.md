## Virtual Neuro Machine

how to build:
```
docker build -t vnm:latest . 
```

how to start local:
```
docker run --name vnm_latest -p 6080:80 -p 5900:5900 -v C:/vnm:/vnm vnm:latest 
open in browser: http://localhost:6080
OR 
VNC viewer on:  http://localhost:5900
```

how to stop:
```
docker stop vnm_latest
```