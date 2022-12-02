#!/usr/bin/env bash

cd /home/ubuntu

#congfig spark
export PATH=$PATH:~/.local/bin
echo  export PATH=/home/ubuntu/spark/bin:$PATH HADOOP_CONF_DIR=/home/ubuntu/hadoop/etc/hadoop export HADOOP_CONF_DIR=/home/ubuntu/hadoop/etc/hadoop export SPARK_HOME=/home/ubuntu/spark export LD_LIBRARY_PATH=/home/ubuntu/hadoop/lib/native:$LD_LIBRARY_PATH | sudo tee .profile
sudo sed -i '/sbin/c export PATH=$PATH:~/.local/bin\nexport PATH=$PATH:/home/ubuntu/hadoop/bin:/home/ubuntu/hadoop/sbin\nSPARK_PATH=/home/ubuntu/spark' ~/.bashrc
source ~/.profile
hdfs dfs -mkdir /spark-logs
sudo sed -i '/# Example:/c # Example:\nspark.master yarn\nspark.yarn.am.memory  512m\nspark.executor.memory 1024m\nspark.eventLog.enabled true\nspark.eventLog.dir hdfs://master:9001/spark-logs\nspark.history.provider org.apache.spark.deploy.history.FsHistoryProvider\nspark.history.fs.logDirectory hdfs://master:9001/spark-logs\nspark.history.fs.update.interval 10s\nspark.history.ui.port 18080' /home/ubuntu/spark/conf/spark-defaults.conf
source ~/.bashrc

#---config jupyter
sudo apt-get install python3-venv -y
python3 -m venv dl-venv
source dl-venv/bin/activate
pip3 install --upgrade pip
pip3 install jupyterlab
jupyter notebook --generate-config
sudo sed -i "/#c.TerminalManager.cull_interval = 300/c c.NotebookApp.ip = "\"0.0.0.0\""\nc.NotebookApp.open_browser = False\nc.NotebookApp.token="\"1234\""\nc.NotebookApp.allow_root=True\nc.NotebookApp.port =4242" .jupyter/jupyter_notebook_config.py

#config kernel
sudo mkdir /home/ubuntu/dl-venv/share/jupyter/kernels/pyspark3/
sudo touch /home/ubuntu/dl-venv/share/jupyter/kernels/pyspark3/kernel.json
 echo '{
      "argv": [
        "python",
        "-m",
        "ipykernel_launcher",
        "-f",
        "{connection_file}"
      ],
      "display_name": "Pyspark 3",
      "language": "python",
      "env": {
        "PYSPARK_PYTHON": "/usr/bin/python3",
        "SPARK_HOME": "/home/ubuntu/spark/",
        "SPARK_OPTS": "--master yarn --conf spark.ui.port=0",
        "SPARK_PATH": "/bin/pyspark --master yarn",
        "PYTHONPATH": "/home/ubuntu/spark/python/lib/py4j-0.10.9.5-src.zip:/home/ubuntu/spark/python/"
      }
}' | sudo tee /home/ubuntu/dl-venv/share/jupyter/kernels/pyspark3/kernel.json
jupyter kernelspec install /home/ubuntu/dl-venv/share/jupyter/kernels/pyspark3 --user
source dl-venv/bin/activate
cd Versionado
start-yarn.sh
jupyter lab && exit




