rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo Input RabbitMQ AppUser Password Missing
  exit 1
fi

log=/tmp/roboshop.log
echo -e "\e[36m >>>>>>>>>>>>Configuring YUM Repos<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Configure YUM Repos for RabbitMQ<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Installing RabbitMQ Server<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install rabbitmq-server -y &>>${log}
echo -e "\e[36m >>>>>>>>>>>>Start RabbitMQ Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
systemctl enable rabbitmq-server
systemctl start rabbitmq-server &>>${log}
echo -e "\e[36m >>>>>>>>>>>>create one user for the application<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
rabbitmqctl add_user roboshop ${rabbitmq_app_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}