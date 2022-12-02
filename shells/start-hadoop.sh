#!/usr/bin/env bash
#Execute config   .profile where is vars
source ~/.profile
#Execute config   .bashrc where is vars
source ~/.bashrc
#format nameNode
 hdfs namenode -format -force
# start dfs hadoop
 start-all.sh






