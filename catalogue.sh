log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating CATALOGUE Servie file<<<<<<<<<<<<<<<< \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Create MONGODB Repo<<<<<<<<<<<<<<<< \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing nodejs Repo<<<<<<<<<<<<<<<< \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Install NODEJS<<<<<<<<<<<<<<<< \e[0m"
yum install nodejs -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Create Application User<<<<<<<<<<<<<<<< \e[0m"
useradd roboshop &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Directory<<<<<<<<<<<<<<<< \e[0m"
rm -rf /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<<< \e[0m"
mkdir /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<< \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip &>>${log}
cd /app
echo -e "\e[36m >>>>>>>>>>>>Download NODEJS Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
npm install &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing MongoClient<<<<<<<<<<<<<<<< \e[0m"
yum install mongodb-org-shell -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>loading Schema<<<<<<<<<<<<<<<< \e[0m"
mongo --host mongodb.mdevopsb74.online </app/schema/catalogue.js &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Daemon-reload Enabling and Restarting<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue