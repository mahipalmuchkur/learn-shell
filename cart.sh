log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating Cart Servie<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp cart.service /etc/systemd/system/cart.service &>>${log}
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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/cart.zip  &>>${log}
cd /app  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Download Nodejs Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
npm install  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Daemon-reload Enabling and Restarting<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
