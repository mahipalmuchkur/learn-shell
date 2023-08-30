log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating Payment Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp payment.service /etc/systemd/system/payment.service &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing Python<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install python36 gcc python3-devel -y  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application User<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
useradd roboshop  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
rm -rf /app  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mkdir /app  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Downloading Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Extraction Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/payment.zip  &>>${log}
cd /app
echo -e "\e[36m >>>>>>>>>>>>Downloading the Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
pip3.6 install -r requirements.txt  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Restarting the Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl daemon-reload
systemctl enable payment
systemctl start payment  &>>${log}