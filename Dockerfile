FROM ubuntu:18.04
LABEL  maintainer "t-koike"

RUN apt-get update && apt-get install -y openssh-server sudo libpam-google-authenticator
RUN mkdir /var/run/sshd

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY sshd_config /root/sshd_config
COPY id_rsa.pub /root/authorized_keys
COPY google-authenticator.sh /etc/profile.d/google-authenticator.sh

RUN sudo sed -i -e "/^@include common-auth$/a auth    required    pam_google_authenticator.so" /etc/pam.d/sshd
RUN sudo sed -i -e "s/^@include common-auth$/#@include common-auth/" /etc/pam.d/sshd

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
