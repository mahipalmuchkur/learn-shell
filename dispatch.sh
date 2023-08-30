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