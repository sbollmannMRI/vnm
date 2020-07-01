

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


