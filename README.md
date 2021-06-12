# Logitech Media Server

Docker image for LMS (Logitech Media Server, SqueezeCenter, SqueezeboxServer, SlimServer)

To run LMS:

docker run -d \
-p 3483:3483/tcp \
-p 3483:3483/udp \
-p 9000:9000/tcp \
-p 9090:9090/tcp \
-e PUID="999" \
-e GUID="1000" \
-v "/mnt/user/appdata/lms":"/config":rw \
-v "/mnt/user/Music":"/music":rw \
-v "/mnt/user/Plugins":"/plugins":rw \
docker.pkg.github.com/andrew-codechimp/lms/lms-image:latest

