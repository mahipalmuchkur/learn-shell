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