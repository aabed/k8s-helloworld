FROM  python
ENV APP /app
EXPOSE 80
WORKDIR $APP
RUN   apt-get install -y dirmngr gnupg \
&&  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \ 
&&  apt-get install -y apt-transport-https ca-certificates \ 
&& sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list' \ 
&& apt-get update \ 
&& apt-get install -y libnginx-mod-http-passenger nginx python-pip \
&& apt-get clean
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY . .
RUN chown www-data:www-data -R /app
CMD nginx -g 'daemon off; error_log /dev/stdout info;'