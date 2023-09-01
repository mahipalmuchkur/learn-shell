log=/tmp/roboshop.log
echo -e "\e[36m Installing nginx server \e[0m"  | tee -a /tmp/roboshop.log
yum install nginx -y &>>${log}
echo -e "\e[36m adding conf \e[0m"
cp frontend.conf /etc/nginx/default.d/roboshop.conf &>>${log}
echo -e "\e[36m Enabling and start \e[0m"
systemctl enable nginx
systemctl start nginx
echo -e "\e[36m Removing Stuff \e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m Downloading roboshop content \e[0m"  | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
cd /usr/share/nginx/html &>>${log}
echo -e "\e[36m extracting roboshop content \e[0m" | tee -a /tmp/roboshop.log
unzip /tmp/frontend.zip &>>${log}
echo -e "\e[36m Restarting nginx server \e[0m"
systemctl restart nginx ; tail -f /var/log/messages