#!/bin/bash  
#abel  
#2017.06  
>/tmp/system.txt  
machine_model=`dmidecode -t system | grep "Product Name"| awk -F":" '{print $2}'`  
serial_num=`dmidecode -t system | grep "Serial Number"| awk -F":" '{print $2}'`  
adapter_watch=`lspci | egrep -i --color 'network|ethernet'`  
#disk=`lsblk | awk '/^(sd|vd|hd)/'|awk '{print $1,"",$4}'`  
disk=`fdisk -l |grep Disk|egrep '/sd|vd|hd/'|awk -F"," '{print $1}'|awk '{print $2,$3}'`  
disk_mount=`df -Th`  
physical_id=`cat /proc/cpuinfo |grep "physical id"|sort|uniq|wc -l`  
cpu_core=` grep 'cpu cores' /proc/cpuinfo | wc -l`  
cpu_model_name=`cat /proc/cpuinfo|grep "model name"|uniq`  
ip_route=`ip route|grep default |awk '{print "Gateway         : "$3}'`  
mem_size=$(dmidecode | grep -A 16 "Memory Device$" |grep Size:|grep -v "No Module Installed"|sort|uniq -c|awk '{printf $1"*"$3" MB" "\n" "\t\t" "  "}')  
mem_type=$(dmidecode | grep -A 16 "Memory Device$" |grep Type:|sort|uniq -c|awk '{print $3}')  
cron_tab=`crontab -l`  
system_version=`cat /etc/*-release |egrep 'Server|Linux|release' |uniq`  
kernel_version=`cat /proc/version  |awk -F"(" '{print $1}'| awk -F" " '{print $3}'`  
system_info=`dmidecode -t system | head -n 15`  
comm_users=`awk -F: '{if($3>=1000) {printf "|%-16s| %-14s|\n", $1,$3}}' /etc/passwd`  
  
  
echo "=============================================================================" >>/tmp/system.txt  
echo "*****************This is the statistical information system!*****************" >>/tmp/system.txt  
echo "=============================================================================" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "###############################00.Machine-Info###############################" >>/tmp/system.txt  
echo "Machine model   :$machine_model" >>/tmp/system.txt  
echo "Serial number   :$serial_num" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "#################################01.CPU-Info#################################" >>/tmp/system.txt  
echo "Physical_id     : $physical_id" >>/tmp/system.txt  
echo "$cpu_model_name" >>/tmp/system.txt  
echo "CPU_core_num    : $cpu_core" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "###############################02.Memory-Info################################" >>/tmp/system.txt  
echo "memory_size     : $mem_size">>/tmp/system.txt  
echo "memory_type     : $mem_type">>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "################################03.DISK-INFO#################################" >>/tmp/system.txt  
echo "Name Size" >>/tmp/system.txt  
echo "$disk" >> /tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "###############################04.Adapter-Info###############################" >>/tmp/system.txt  
echo "$adapter_watch" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "#################################05.HBA-Info#################################" >>/tmp/system.txt  
for i in `ls -lh /sys/class/fc_host/ | grep -v "total 0"|awk '{print $9}'`  
do   
echo "$i           : `cat /sys/class/fc_host/$i/port_name`" >>/tmp/system.txt  
done  
echo "" >>/tmp/system.txt  
echo "####################06.System-Version And Kernel-Version#####################" >>/tmp/system.txt  
echo "System-Version  : $system_version" >>/tmp/system.txt  
echo "Kernel-Version  : $kernel_version" >> /tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "##################################07.IP-Info#################################" >>/tmp/system.txt  
for i in $(cat /proc/net/dev|sed '1,2d'|grep -v "lo"|awk -F ":" '{print $1}')  
do  
/sbin/ifconfig $i|egrep "inet"|grep -v "inet6"|awk '{print "'$i'            :",$2,"/ "$4}' >>/tmp/system.txt  
/sbin/ifconfig $i|egrep "ether|HWaddr" |awk '{if( $1=="ether" ) {print "'$i'_HWaddr     :",$2} else {print "'$i'_HWaddr     :",$5}}' >>/tmp/system.txt  
echo "----------------------------------------------------------------------------" >>/tmp/system.txt  
done  
echo "$ip_route" >> /tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "##############################08.Disk-Mount-Info#############################" >>/tmp/system.txt  
echo "$disk_mount" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "################################09.Comm-users################################" >>/tmp/system.txt  
echo "Comm-Users      : " >>/tmp/system.txt  
echo -e '|NAME \t\t | UID \t\t |'>>/tmp/system.txt  
echo "$comm_users" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "###################################10.Java###################################" >>/tmp/system.txt  
  
  
ps -ef | grep java |grep -v grep &>/dev/null  
if [ $? -eq 0 ];then  
echo "Java is Ok!" >> /tmp/system.txt  
echo "##################################11.Oracle##################################" >>/tmp/system.txt  
echo "" >>/tmp/system.txt  
else    
echo "Java is Down!" >> /tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "##################################11.Oracle##################################" >>/tmp/system.txt  
fi  
  
  
ps -ef | grep oracle |grep -v grep &>/dev/null  
if [ $? -eq 0 ];then  
echo "Oracle is Ok£¡" >> /tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "#################################12.Crontab##################################" >>/tmp/system.txt  
else  
echo "Oracle is Down£¡" >> /tmp/system.txt  
echo "" >>/tmp/system.txt  
echo "#################################12.Crontab##################################" >>/tmp/system.txt  
fi  
  
  
crontab -l &>/dev/null  
if [ $? -eq 0 ];then  
echo "cron_tab: $cron_tab" >>/tmp/system.txt  
echo "#############################################################################" >>/tmp/system.txt  
else  
echo "no cron_tab!" >>/tmp/system.txt  
echo "#############################################################################" >>/tmp/system.txt  
fi  
  
  
cat /tmp/system.txt && rm -rf /tmp/systeminfo.sh && rm -rf /tmp/system.txt  