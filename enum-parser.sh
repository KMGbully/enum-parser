#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage:  ./enum-parser.sh <enum4linux file>"
  exit 0
fi

echo $(tput setaf 3)Parsing Domain Admins to txt file:$(tput setaf 7)  Domain_Admins.txt
grep "RID: 512" $1 | awk '{print $8}' | cut -d '\' -f2 | tee Domain_Admins.txt
echo " "

echo $(tput setaf 3)Parsing Domain Users to txt file:$(tput setaf 7)  Domain_Users.txt
grep "RID: 513" $1 | awk '{print $8}' | cut -d '\' -f2| tee Domain_Users.txt
echo " "

echo $(tput setaf 3)Parsing Domain Computers to txt file:$(tput setaf 7)  Domain_Computers.txt
grep "RID: 515" $1 | awk '{print $8}' | cut -d '\' -f2 | cut -d "$" -f1 | tee Domain_Computers.txt
echo " "

echo $(tput setaf 3)Parsing Domain Controllers to txt file:$(tput setaf 7)  Domain_Controllers.txt
grep "RID: 516" $1 | awk '{print $8}' | cut -d '\' -f2 | cut -d "$" -f1 | tee Domain_Controllers.txt
echo " "

echo $(tput setaf 3)Parsing Domain Password Policy to txt file:$(tput setaf 7)  Domain_PasswordPolicy.txt
grep -A 25 "Password Info for Domain" $1 | tee Domain_PasswordPolicy.txt
echo " "

echo $(tput setaf 3)Resolving Domain Computers to IP Addresses:$(tput setaf 7)  Domain_Computers_IP.txt

for ip in $(cat Domain_Computers.txt); do
  host $ip | grep "has address" | awk '{print $4}' | tee -a Domain_Computers_IP.txt &
done
