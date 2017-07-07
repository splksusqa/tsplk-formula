#adduser --disabled-password --gecos "" splunk
#su - splunk -c "mkdir /home/splunk/.ssh"
#su - splunk -c "chmod 700 /home/splunk/.ssh"
#cp /home/$login_user/.ssh/authorized_keys /home/splunk/.ssh/authorized_keys
#chown splunk /home/splunk/.ssh/authorized_keys
#su - splunk -c "chmod 600 /home/splunk/.ssh/authorized_keys"
#echo "splunk ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
splunk:
  user.present:
    - empty_password: True

# if you're ec2 instance, copy key to let user ssh easier to operator splunk
