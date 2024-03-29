sudo docker build -t favicon-downloader . #.  если dockerfile находиться в той директории откуда запускаеться docker
sudo docker images # Смотрим образ
REPOSITORY           TAG       IMAGE ID       CREATED          SIZE
favicon-downloader   latest    60310d230840   32 minutes ago   14.8MB

sudo docker run -e SITE_URL=https://example.com favicon-downloader # Запускаем docker
sudo docker ps -a
sudo docker stop $(sudo docker ps -a -q) # Остановить все docker
sudo docker rm $(sudo docker ps -a -q) # Удалить все 
