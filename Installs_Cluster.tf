
resource "null_resource" "master"  {


  connection {

    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.ssh_key_path)
    host     = aws_instance.master_node.public_ip

  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt-get update",
      "sudo apt-get install git",
      "sudo apt install openssh-server openssh-client -y",
      "cd /home/ubuntu",
      "echo 'export HADOOP_HOME=/home/ubuntu/hadoop\nexport PATH=$PATH:/home/ubuntu/hadoop/bin:/home/ubuntu/hadoop/sbin'| sudo tee .bashrc",
      "echo '127.0.0.1 localhost\n${aws_instance.master_node.private_ip} master\n${aws_instance.slave_node.0.private_ip} slave01\n${aws_instance.slave_node.1.private_ip} slave02' | sudo tee /etc/hosts",
      "echo 'PATH=/home/hadoop/hadoop/bin:/home/hadoop/hadoop/sbin:$PATH' | sudo tee .profile",
      "echo config spark",
      "wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz",
      "tar -xvf spark-3.3.0-bin-hadoop3.tgz",
      "mv spark-3.3.0-bin-hadoop3 spark",
      "mv /home/ubuntu/spark/conf/spark-defaults.conf.template /home/ubuntu/spark/conf/spark-defaults.conf",
      "wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz",
      "sudo tar -xvzf hadoop-3.3.0.tar.gz",
      "mv hadoop-3.3.0 hadoop",
      "sudo rm -r hadoop.tar.gz",
      "sudo rm -r spark-3.3.0-bin-hadoop3.tgz",
      "sudo rm -r hadoop-3.3.0.tar.gz",
      "sudo usermod -a -G sudo ubuntu",
      "sudo chown ubuntu:root -R /home/ubuntu/hadoop/",
      "sudo chmod g+rwx -R /home/ubuntu/hadoop/",
      "sudo adduser ubuntu sudo",
      "sudo mkdir /home/ubuntu/tmpdata/",
      "sudo mkdir /home/ubuntu/hadoop/tmp/dir",
      "sudo mkdir /home/ubuntu/hadoop/hdfs",
      "sudo mkdir /home/ubuntu/hadoop/hdfs/datanode",
      "sudo mkdir /home/ubuntu/hadoop/hdfs/namenode",
      "sudo chown -R ubuntu /home/ubuntu/hadoop/hdfs/",
      "cd /home/ubuntu/hadoop",
      "sudo mkdir /ruta",
      "sudo chown -R ubuntu /home/ubuntu/hadoop/",
      "cd /home/ubuntu/hadoop/etc/hadoop",
      "echo ¡configuración archivos!",
      "sudo sed -i '/<configuration>/c <configuration><property><name>fs.default.name</name><value>hdfs://master:9001</value></property>' core-site.xml",
      "sudo sed -i '/<configuration>/c <configuration><property><name>dfs.replication</name><value>2</value></property><property><name>dfs.namenode.name.dir</name><value>file:/home/ubuntu/hadoop/hdfs/namenode</value></property><property><name>dfs.datanode.data.dir</name><value>file:/home/ubuntu/hadoop/hdfs/datanode</value></property>' hdfs-site.xml",
      "sudo sed -i '/<configuration>/c <configuration><property><name>mapreduce.framework.name</name><value>yarn</value></property><property><name>yarn.app.mapreduce.am.env</name><value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value></property><property><name>mapreduce.map.env</name><value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value></property><property><name>mapreduce.reduce.env</name><value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value></property><property><name>yarn.app.mapreduce.am.resource.mb</name><value>2048</value></property><property><name>mapreduce.map.memory.mb</name><value>1024 </value></property><property><name>mapreduce.reduce.memory.mb</name><value>1024</value></property>' mapred-site.xml",
      "sudo sed -i '/<configuration>/c <configuration><property><name>yarn.acl.enable</name><value>0</value></property><property><name>yarn.resourcemanager.hostname</name><value>${aws_instance.master_node.private_ip}</value></property><property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property><property><name>yarn.nodemanager.resource.memory-mb</name><value>9216</value></property><property><name>yarn.scheduler.maximum-allocation-mb</name><value>6144</value></property><property><name>yarn.scheduler.minimum-allocation-mb</name><value>1024</value></property><property><name>yarn.nodemanager.vmem-check-enabled</name><value>false</value></property>' yarn-site.xml",
      "echo '${aws_instance.master_node.private_ip} master\n${aws_instance.slave_node.0.private_ip} slave01\n${aws_instance.slave_node.1.private_ip} slave02' | sudo tee host.xml",
      "echo '${aws_instance.slave_node.0.private_ip} slave01\n${aws_instance.slave_node.1.private_ip} slave02' | sudo tee  workers",
      "sudo apt-get update",
      "sudo apt install openjdk-8-jdk -y",
      "echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre' | sudo tee hadoop-env.sh",
      "cd ~/",
      "tar -zcvf hadoop.tar.gz hadoop",
      "scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${var.ssh_key_path} ~/hadoop.tar.gz ubuntu@slave01:/home/ubuntu",
      "scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${var.ssh_key_path} ~/hadoop.tar.gz ubuntu@slave02:/home/ubuntu",
      "echo ¡configuración hadoop master ok!",
      "ssh -o 'StrictHostKeyChecking no' ubuntu@slave01 exit ",
      "ssh -o 'StrictHostKeyChecking no' ubuntu@slave02 exit ",
      "ssh -o 'StrictHostKeyChecking no' ubuntu@master  exit",
      "ssh -o 'StrictHostKeyChecking no' ubuntu@localhost  exit",
      "ssh -o 'StrictHostKeyChecking no' ubuntu@0.0.0.0  exit",
    ]
  }

  depends_on = [
    aws_instance.slave_node,aws_instance.master_node
  ]
}
resource "null_resource" "Hadoop_slaves" {
  depends_on = [null_resource.master]

  count = var.cluster_size
  connection {
    user = "ubuntu"
    private_key = file(var.ssh_key_path)
    type = "ssh"
    timeout = "1m"
    host = element(aws_instance.slave_node.*.public_ip, count.index)
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt-get update",
      "sudo apt install openjdk-8-jdk -y",
      "echo '127.0.0.1 localhost\n${aws_instance.master_node.private_ip} master\n${aws_instance.slave_node.0.private_ip} slave01\n${aws_instance.slave_node.1.private_ip} slave02' | sudo tee /etc/hosts",
      "sudo apt install openssh-server openssh-client -y",
      "cd /home/ubuntu",
      "sudo tar -xvzf hadoop.tar.gz",
      "sudo usermod -a -G sudo ubuntu",
      "sudo chown ubuntu:root -R /home/ubuntu/hadoop/",
      "sudo chmod g+rwx -R /home/ubuntu/hadoop/",
      "sudo adduser ubuntu sudo"
    ]
  }

}
resource "null_resource" "run_cluster" {
  depends_on = [null_resource.master,null_resource.Hadoop_slaves]

  connection {

    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.ssh_key_path)
    host     = aws_instance.master_node.public_ip

  }

  provisioner "remote-exec" {

    inline = [

      "bash /tmp/start-hadoop.sh",
      "bash /tmp/setup-spark-jupyter.sh"
    ]
  }

}

