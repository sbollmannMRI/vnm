## Virtual Neuro Machine

how to build:
```
docker build -t vnm:latest . 
```

how to start local:
```
docker run --name vnm -p 6080:80 -v C:/vnm:/vnm vnm:latest 
open in browser: http://localhost:6080
```

how to stop:
```
docker stop vnm
```