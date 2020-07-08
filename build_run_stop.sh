sudo docker build -t vnm:latest . && (
    echo "Starting VNM:"
    sudo docker images
    sudo docker run -d --privileged --name vnm -v ~/vnm:/vnm -p 6080:80 -p 5900:5900 vnm:latest
    read -e -p "VNM is running - press ENTER key to shutdown and quit VNM!" check
    sudo docker stop vnm
    sudo docker rm vnm
) || (
    echo "-------------------------"
    echo "Docker Build failed!"
    echo "-------------------------"
)