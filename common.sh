log=/tmp/roboshop.log

func_exit_status(){
      if [ $? -eq 0 ]; then
          echo -e "\e[36m SUCCESS \e[0m"
        else
          echo -e "\e[31m FAILURE \e[0m"
      fi
}
func_appreq(){
  echo -e "\e[36m >>>>>>>>>>>>Creating ${component} Servie<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  func_exit_status

   echo -e "\e[36m >>>>>>>>>>>>Creating Application ${component}<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log

    id roboshop &>>${log}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${log}
    fi

 func_exit_status

    echo -e "\e[36m >>>>>>>>>>>>Cleaning Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
    rm -rf /app &>>${log}

  func_exit_status


    echo -e "\e[36m >>>>>>>>>>>>Creating Application Directory<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
    mkdir /app &>>${log}

  func_exit_status

    echo -e "\e[36m >>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

  func_exit_status

    echo -e "\e[36m >>>>>>>>>>>>Extract Application Content<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
    cd /app &>>${log}
    unzip /tmp/${component}.zip &>>${log}
    cd /app &>>${log}

  func_exit_status
}
func_systemd(){
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component} ; tail -f /var/log/messages
}

func_schema_setup(){
  if [ "${schema_type}" == "mongodb" ]; then
      echo -e "\e[36m >>>>>>>>>>>>Installing Mongo Client<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
      yum install mongodb-org-shell -y &>>${log}

func_exit_status

      echo -e "\e[36m >>>>>>>>>>>>Loading Schema<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
      mongo --host mongodb.mdevopsb74.online </app/schema/${component}.js &>>${log}
  fi

func_exit_status

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m >>>>>>>>>>>>Installing MySQL<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
      yum install mysql -y  &>>${log}

      func_exit_status

      echo -e "\e[36m >>>>>>>>>>>>online -uroot -pRoboShop@1<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
      mysql -h mysql.mdevopsb74.online -uroot -pRoboShop@1 < /app/schema/${component}.sql  &>>${log}
  fi
    func_exit_status

}
func_nodejs(){


  echo -e "\e[36m >>>>>>>>>>>>Creating Mongo repo file<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>Installing Nodejs Repo<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>Install Nodejs<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  yum install nodejs -y &>>${log}

func_exit_status

  func_appreq

  echo -e "\e[36m >>>>>>>>>>>>Download Nodejs Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  npm install &>>${log}

func_schema_setup
func_exit_status


  echo -e "\e[36m >>>>>>>>>>>>Daemon-reload Enabling and Restarting<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log

  func_systemd

func_exit_status

}

func_java(){


  echo -e "\e[36m >>>>>>>>>>>>Installing Maven<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  yum install maven -y  &>>${log}

func_exit_status

  func_appreq

func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>Cleaning Maven Package<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  mvn clean package  &>>${log}
  echo -e "\e[36m >>>>>>>>>>>>Moving ${component} jar<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  mv target/${component}-1.0.jar ${component}.jar  &>>${log}
  echo -e "\e[36m >>>>>>>>>>>>DaemonReload and enable start<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log

  func_schema_setup
  func_systemd

func_exit_status


  systemctl restart ${component}
}

func_python(){

echo -e "\e[36m >>>>>>>>>>>>Installing Python<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
yum install python36 gcc python3-devel -y  &>>${log}

func_exit_status

func_appreq

func_exit_status

echo -e "\e[36m >>>>>>>>>>>>Downloading the Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
pip3.6 install -r requirements.txt  &>>${log}

func_exit_status

echo -e "\e[36m >>>>>>>>>>>>Restarting the Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log

func_exit_status

func_systemd

}

func_golang(){

  echo -e "\e[36m >>>>>>>>>>>>Installing Golang<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  yum install golang -y   &>>${log}

func_exit_status

  func_appreq

  echo -e "\e[36m >>>>>>>>>>>>Downloading Dependencies<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log
  go mod init dispatch   &>>${log}

  go get   &>>${log}

  go build   &>>${log}

  echo -e "\e[36m >>>>>>>>>>>>Loading the Service<<<<<<<<<<<<<<<< \e[0m"  | tee -a /tmp/roboshop.log

  func_systemd

func_exit_status
}