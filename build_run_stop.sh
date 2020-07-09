sudo docker build -t vnm:latest . && (
    echo "Starting VNM:"
    # sudo docker run -d --privileged --name vnm -v /vnm:/vnm -e RESOLUTION=1920x990 -p 6080:80 -p 5900:5900 vnm:latest
    sudo docker run -d --privileged --name vnm -v /vnm:/vnm -e RESOLUTION=1280x680 -p 6080:80 -p 5900:5900 vnm:latest
    read -e -p "VNM is running - press ENTER key to shutdown and quit VNM!" check
    sudo docker stop vnm
    sudo docker rm vnm
) || (
    echo "-------------------------"
    echo "Docker Build failed!"
    echo "-------------------------"
)