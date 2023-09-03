source common.sh

echo -e "\e[36m Installing nginx server \e[0m"  | tee -a /tmp/roboshop.log
yum install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m copy roboshop configuration \e[0m"
cp frontend.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status


echo -e "\e[36m Clean Old Content \e[0m"
rm -rf /usr/share/nginx/html/*
func_exit_status

echo -e "\e[36m Download Application Content \e[0m"  | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

cd /usr/share/nginx/html &>>${log}

echo -e "\e[36m Extract Application Content \e[0m" | tee -a /tmp/roboshop.log
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m Start Nginx Server \e[0m"
systemctl enable nginx
systemctl restart nginx ; tail -f /var/log/messages
func_exit_status