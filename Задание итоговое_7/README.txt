docker build -t my-post-bd . # создаем образ
docker build -t my-post-bd .
[+] Building 4.8s (11/11) FINISHED                                                                                                                                                           docker:default
 => [internal] load build definition from dockerfile                                                                                                                                                   0.0s
 => => transferring dockerfile: 860B                                                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/python:3                                                                                                                                            4.5s
 => [internal] load .dockerignore                                                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                                                        0.0s
 => [1/6] FROM docker.io/library/python:3@sha256:19973e1796237522ed1fcc1357c766770b47dc15854eafdda055b65953fe5ec1                                                                                      0.0s
 => [internal] load build context                                                                                                                                                                      0.0s
 => => transferring context: 55B                                                                                                                                                                       0.0s
 => CACHED [2/6] RUN pip install Flask psycopg2-binary configparser                                                                                                                                    0.0s
 => CACHED [3/6] WORKDIR /srv/app                                                                                                                                                                      0.0s
 => CACHED [4/6] RUN mkdir -p conf                                                                                                                                                                     0.0s
 => CACHED [5/6] COPY web.py ./                                                                                                                                                                        0.0s
 => CACHED [6/6] COPY web.conf ./conf/                                                                                                                                                                 0.0s
 => exporting to image                                                                                                                                                                                 0.0s
 => => exporting layers                                                                                                                                                                                0.0s
 => => writing image sha256:1f2544c666f142010eb4ae40aee0a4a797443c463ab011ac06c72f09c1ad1352                                                                                                           0.0s
 => => naming to docker.io/library/my-post-bd                   


docker images  # размер образа

REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
my-post-bd   latest    1f2544c666f1   15 minutes ago   1.04GB

docker run -d -p 5000:5000 my-post-bd #запускаем докер

docker run  -p 80:5000 -v /srv/app:/srv/app my-post-bd   #запуск Docker-контейнер, смонтировав /srv/app с хостовой ФС в контейнерную, а также пробросив порт 80 из контейнера в хостовую сеть.
docker run  -p 80:5000 -v /srv/app:/srv/app my-post-bd ls -laR /srv/
/srv/:
total 16
drwxr-xr-x 1 root root 4096 Mar 29 09:00 .
drwxr-xr-x 1 root root 4096 Mar 29 11:54 ..
drwxr-xr-x 3 root root 4096 Mar 29 11:54 app

/srv/app:
total 20
drwxr-xr-x 3 root root 4096 Mar 29 11:54 .
drwxr-xr-x 1 root root 4096 Mar 29 09:00 ..
drwxr-xr-x 2 root root 4096 Mar 29 11:54 conf
-rw-r--r-- 1 root root 1115 Mar 29 10:56 web.py

/srv/app/conf:
total 12
drwxr-xr-x 2 root root 4096 Mar 29 11:54 .
drwxr-xr-x 3 root root 4096 Mar 29 11:54 ..
-rw-r--r-- 1 root root  124 Mar 29 11:32 web.conf



