echo -e "\e[31m Installing nginx server \e[0m"
yum install nginx -y
echo -e "\e[31m adding conf \e[0m"
cp frontend.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[31m Enabling and start \e[0m"
systemctl enable nginx
systemctl start nginx
echo -e "\e[31m Removing Stuff \e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[31m Downloading roboshop content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
echo -e "\e[31m extracting roboshop content \e[0m"
unzip /tmp/frontend.zip
echo -e "\e[31m Restarting nginx server \e[0m"
systemctl restart nginx ; tail -f /var/log/messages