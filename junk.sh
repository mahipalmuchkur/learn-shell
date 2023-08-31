log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating CATALOGUE Servie file<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Create MONGODB Repo<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing nodejs Repo<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Install NODEJS<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install nodejs -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Create Application User<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
useradd roboshop &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Directory<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
rm -rf /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mkdir /app &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip &>>${log}
cd /app
echo -e "\e[36m >>>>>>>>>>>>Download NODEJS Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
npm install &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing MongoClient<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>loading Schema<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mongo --host mongodb.mdevopsb74.online </app/schema/catalogue.js &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Daemon-reload Enabling and Restarting<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue



log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating Shipping Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp shipping.service /etc/systemd/system/shipping.service &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing Maven<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install maven -y  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application user<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
useradd roboshop  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
rm -rf /app  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mkdir /app  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Downloading Application Conntent<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/shipping.zip  &>>${log}
cd /app
echo -e "\e[36m >>>>>>>>>>>>Cleaning Maven Package<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mvn clean package  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Moving Shipping jar<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>DaemonReload and enable start<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
echo -e "\e[36m >>>>>>>>>>>>Installing MySQL<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install mysql -y  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>online -uroot -pRoboShop@1<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mysql -h mysql.mdevopsb74.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>${log}
systemctl restart shipping


log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating Dispatch Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp dispatch.service /etc/systemd/system/dispatch.service  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing Golang<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install golang -y   &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application user<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
useradd roboshop   &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
rm -rf /app   &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mkdir /app   &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Downloading Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip   &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extracting Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/dispatch.zip   &>>${log}
cd /app
echo -e "\e[36m >>>>>>>>>>>>Downloading Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
go mod init dispatch   &>>${log}
go get   &>>${log}
go build   &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Loading the Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch ; tail -f /var/log/messages   &>>${log}