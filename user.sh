log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating User Servie<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp user.service /etc/systemd/system/user.service &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Mongo repo file<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing Nodejs Repo<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Install Nodejs<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install nodejs -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application user<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
useradd roboshop &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
rm -rf /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mkdir /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/user.zip
cd /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Download Nodejs Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
npm install &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing Mongo Client<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Loading Schema<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mongo --host mongodb.mdevopsb74.online </app/schema/user.js &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Daemon-reload Enabling and Restarting<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable user
systemctl start user
