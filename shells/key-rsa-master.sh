echo "Generating cluster's SSH key on master..."
if [ -f ~/.ssh/id_rsa ] ||
    (ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa &&
     cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys); then

  echo "Cluster SSH keys generated successfully."
fi

