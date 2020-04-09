if [ "$USER" != "root" -a "$USER" != "ec2-user" ]; then
  if [ ! -f "$HOME/.google_authenticator" ]; then
    trap 'exit' SIGINT
    echo "Initialize google-authenticator"
    /usr/bin/google-authenticator -t -d -W -u -f
    sudo mv /root/sshd_config /etc/ssh/sshd_config
    sudo /etc/init.d/ssh reload
    trap -- SIGINT
  fi
fi
