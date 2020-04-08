FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY id_rsa.pub /root/authorized_keys
RUN useradd -m -d /home/login.user -s /bin/bash login.user \
 && echo "login.user:test_pass" | chpasswd \
 && mkdir /home/login.user/.ssh \
 && chmod 700 /home/login.user/.ssh \
 && cp /root/authorized_keys /home/login.user/.ssh \
 && chmod 600 /home/login.user/.ssh/authorized_keys \
 && chown -R login.user:login.user /home/login.user/.ssh

RUN echo "login.user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

EXPOSE 22

CMD /usr/sbin/sshd -D
