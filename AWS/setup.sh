# You can use this as a rough script to follow along to setup the 
# ec2 instance and launch spark
# See the pdf slides for more info.
# -- Andrew Peterson

#----------------------------------------------------------
#  launch & terminate cluster
#----------------------------------------------------------
git clone https://github.com/aristotle-tek/cuny-bdif.git

cd AWS/ec2

# to launch
export AWS_ACCESS_KEY_ID=<insert your key id>
export AWS_SECRET_ACCESS_KEY=<insert your access key>

# Next, generate a private key. Instructions are here:
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
# You will need to setup amazon command line tools (e.g. apt-get install awscli or pip install awscli)

# the cluster names (at the end "my-spark-cluster") have to be unique, so change it slightly. Replace <privatekey> and <filepath> for your key.
./spark-ec2 --key-pair=<privatekey> --identity-file=/<filepath>/<privatekey>.pem -t m3.large --ebs-vol-size 30 --region=us-east-1 -s 1 launch my-spark-cluster
# > Spark standalone cluster started at http://ec2-54-210-189-190.compute-1.amazonaws.com:8080

# to login
./spark-ec2 --key-pair=<privatekey> --identity-file=/<filepath>/<privatekey>.pem login my-spark-cluster

#Stop the cluster temporarily (still paying for ebs store, not for compute)
./spark-ec2 --region=us-east-1 stop my-spark-cluster
# restart it:
./spark-ec2 -i <privatekey>.pem  --region=us-east-1 start my-spark-cluster

# destroy instance, including EBS:
./spark-ec2 --region=us-east-1 destroy my-spark-cluster


#----------------------------------------------------------
# install pip, aws commandline tools
#----------------------------------------------------------
# the spark cluster you've started does not have aws cli installed, and it is not available through yum.
# instead, first install pip, then pip install it:


#http://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-with-pip
curl -O https://bootstrap.pypa.io/get-pip.py
sudo python27 get-pip.py
pip install awscli

# Need ~/bin to be in PATH var for the symlink to work:
# See if $PATH contains ~/bin (if not, output is null)
echo $PATH | grep ~/bin     
export PATH=~/bin:$PATH

aws configure
# enter key ID & secret key, can ignore region & format.


# Optional: install tmux to allow multiple windows through the same ssh, etc.
sudo yum install tmux
tmux

#-------------------------
#  load json
#-------------------------
# you may first need to mount the ebs volume, since you will not have enough space in the home volume.
# You first need to find where the drive is with
df -h
# then, if it is, say /dev/sdb/, and you want to mount it at a folder called ebsvol, you would use:
mkdir ebsvol
mount /deb/sdb/ ebsvol

#now you can use this volume just like any other folder:
cd ebsvol

aws s3 cp s3://bdif-tweets/sample/sampletweets.tar sample.tar

tar -xvf sample.tar

# to access hadoop, need its path (there are 2 possibilities)
export PATH=$PATH:/root/ephemeral-hdfs/bin

hadoop fs -mkdir tweets
hadoop fs -ls
hadoop fs -put *.json tweets/

# now see cuny-bdif/Spark/tweets.scala

#-------------------------
#  load csv
#-------------------------
cd ebsvol
mkdir csv; cd csv
aws s3 cp s3://bdif-tweets/cleaned/2013-01/clean-tweets-p1.tar.bz2 p1.tar.bz
bunzip2 p1.tar.bz
tar -xvf p1.tar

hadoop fs -mkdir csv
hadoop fs -ls
# for now just put 1st file:
hadoop fs -put *0.csv csv/

#-------------------------
#  create a text file
#-------------------------
echo "This file is a very simple text file that we will use to count how many words are in a simple file." > test.txt
hadoop fs -put test.txt tweets/
#-------------------------





# (optional) change logging, e.g. from INFO to DEBUG
# need to work on this...
#nano /root/ephemeral-hdfs/conf/log4j.properties
# then need to propagate...


