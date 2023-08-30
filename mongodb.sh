log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>mongo repo files<<<<<<<<<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log
echo -e "\e[36m >>>>>>>>>>>>Installing mongoDB<<<<<<<<<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
yum install mongodb-org -y &>>$log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/monogo.conf
#Update listen address
echo -e "\e[36m >>>>>>>>>>>>Enabling and restarting mongodb<<<<<<<<<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable mongod
systemctl start mongod
systemctl restart mongod &>>$log