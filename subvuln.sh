#!/bin/sh
BRed="\033[1;31m"  
clear="\033[0m"
Green="\033[0;32m"
Orange="\033[0;33m"
echo " _____              __  __                _    
|  __ \            |  \/  |              | |   
| |__) |___  _ __  | \  / |  ___   _ __  | | __
|  ___// _ \| '_ \ | |\/| | / _ \ | '_ \ | |/ /
| |   |  __/| | | || |  | || (_) || | | ||   < 
|_|    \___||_| |_||_|  |_| \___/ |_| |_||_|\_\  by ${BRed}K4rth1k${clear}"
                                             
echo ""
mkdir -p /home/$USER/.penmonk
echo "#############################################"
echo ""					          
echo "Checking Requirments...."

if subfinder --version>/dev/null 2>&1;
then
echo "Subfinder already Installed. [200]"
else
echo "Subfinder Not Installed, Installing Subfinder [404]"
sudo apt-get install subfinder
fi

if command -v subzy >/dev/null 2>&1;
then
echo "Subzy already Installed. [200]"
else
echo "Subzy is Not installed, Installing Subzy [404]"
sudo go install -v github.com/LukaSikic/subzy@latest
fi

if command -v httpx --version >/dev/null 2>&1
then
echo "Httpx already Installed. [200]"
else
echo "Httpx is not Installed, Installing Httpx [404]"
sudo go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
fi
echo "Requirement Satisfied [done]"
echo ""
echo "#############################################"
echo ""
echo -n "Output Folder Name: "
read dir_name
mkdir -p /home/$USER/.penmonk/$dir_name
echo "${BRed}$dir_name${clear}"


echo -n "Enter the Domain Name: "
read domain_name
echo "${BRed}$domain_name${clear}"

echo "${Orange}Searching Subdomains...${clear}"
subfinder -d $domain_name -o /home/$USER/.penmonk/$dir_name/$domain_name.subdomains.txt >/dev/null 2>&1

echo "${Orange}Searching Subdomain Takeovers...${clear}"
subzy run --targets /home/$USER/.penmonk/$dir_name/$domain_name.subdomains.txt | tee /home/$USER/.penmonk/$dir_name/$domain_name.subzy.txt>/dev/null 2>&1

echo "${Orange}Gathering Accessible Subdomains...${clear}"
cat /home/$USER/.penmonk/$dir_name/$domain_name.subdomains.txt| httpx -silent| tee /home/$USER/.penmonk/$dir_name/$domain_name.httpx.txt > /dev/null 2>&1
echo "${BRed}Subdomains of $domain_name${clear}"
cat /home/$USER/.penmonk/$dir_name/$domain_name.subdomains.txt
echo ""
echo "${BRed}Subdomain Takeovers${clear}"
cat /home/$USER/.penmonk/$dir_name/$domain_name.subzy.txt
echo ""
echo "${BRed}Accessible Subdomains${clear}"
cat /home/$USER/.penmonk/$dir_name/$domain_name.httpx.txt
echo ""
echo "${Green}Output Files are stored in /home/$USER/.penmonk/$dir_name${clear}"
