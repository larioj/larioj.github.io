FROM panubo/sshd:1.0.3

COPY authorized_keys/larioj /etc/authorized_keys/larioj
ENV SSH_USERS larioj:501:501
ENV SSH_ENABLE_ROOT false
RUN echo 'StrictModes no' >> /etc/ssh/sshd_config
RUN echo 'Port 2222' >> /etc/ssh/sshd_config
