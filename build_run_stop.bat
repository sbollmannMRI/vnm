docker build -t vnm:latest .
REM docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -p 6080:80 vnm:latest
docker run --privileged -e USER=neuro -e PASSWORD=neuro --name vnm -v C:/vnm:/vnm -e RESOLUTION=1920x980 -p 6080:80 -p 5900:5900 vnm:latest 
REM docker stop vnm; docker rm vnm