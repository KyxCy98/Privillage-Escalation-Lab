FROM ubuntu:22.04

# Install services
# Setup depencies in lab
RUN apt-get update && apt-get install -y \
    openssh-server sudo python3 cron

# Create SSH run directory
# Information
# kalo ssh l nyangkut di port 3333 lu kill/hapus aaja nanti normal lagi
RUN mkdir -p /var/run/sshd

# Add users
RUN useradd -m analyst && echo "analyst:analyst" | chpasswd
RUN useradd -m sysbackup  && echo "sysbackup:nathanmime"  | chpasswd
RUN echo "sysbackup ALL=(root) NOPASSWD: /usr/bin/python3 /opt/app/backup.py" >> /etc/sudoers

# Copy application and scripts
COPY app/backup.py /opt/app/backup.py
COPY scripts/backup.sh /opt/scripts/backup.sh

# Copy flag files & Copy clue files
RUN mkdir /home/analyst/.-iamatomic
COPY clue/clue.txt /home/analyst/.-
COPY flags/user.txt /home/analyst/.-iamatomic/-
COPY flags/root.txt /root/r00t-F1@g.txt

# SSH banner
COPY etc/banner.txt /etc/banner.txt
RUN echo "Banner /etc/banner.txt" >> /etc/ssh/sshd_config

# Set permissions
RUN chmod 755 /opt/scripts/backup.sh
RUN chmod 700 /home/analyst
RUN chmod 444 /home/analyst/.-
RUN chmod 444 /home/analyst/.-iamatomic/-   # Owned by backup
RUN chgrp -R sysbackup /opt/app && chmod -R g+rwX /opt/app
# RUN chmod 600 /home/analyst/-             # Only backup can read
RUN chmod 600 /root/r00t-F1@g.txt                      # Only root can read

# (Optional: set immutable bit as extra protection)
# RUN chattr +i /home/analyst/"User Flag.txt"
# RUN chattr +i /root/r00t-F1@g.txt

# Setup cron job for backup user
RUN echo "* * * * * sysbackup /opt/scripts/backup.sh" >> /etc/crontab

# Copy entrypoint and make executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
