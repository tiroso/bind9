# bind9

docker run -d \
  --name bind9 \
  --restart always \
  -p 10000:10000 \
  -p 53:53/udp \
  -p 53:53 \
  -v bind9:/etc/bind \
  -v bind9zones:/var/lib/bind \
  bindserver:dev
