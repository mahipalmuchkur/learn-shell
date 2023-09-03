mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo Input Password Missing
  exit 1
fi

log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Creating MySQL Repo<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Mysql module disable<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum module disable mysql -y  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing MYSQL Community Server<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install mysql-community-server -y  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Enabling and start mysql<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl enable mysqld
systemctl start mysqld  &>>${log}
echo -e "\e[36m >>>>>>>>>>>>mysql_secure_installation --set-root-pass RoboShop@1<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>${log}
#mysql -uroot -pRoboShop@1
echo -e "\e[36m >>>>>>>>>>>>Restart MYSQL<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl restart mysqld ; tail -f /var/log/messages  &>>${log}