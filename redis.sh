log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Installing Remirepo<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Enabling redis module<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum module enable redis:remi-6.2 -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Changing Listen Address<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing redis<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install redis -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Enabling and restart<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl enable redis
systemctl restart redis

