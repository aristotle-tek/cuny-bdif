# You can use this as a rough script to follow along to setup the 
# ec2 instance and launch spark


#----------------------------------------------------------
#  launch & terminate cluster
#----------------------------------------------------------
git clone https://github.com/aristotle-tek/cuny-bdif.git

cd AWS/ec2

# to launch
./spark-ec2 --key-pair=smallhands --identity-file=smallhands.pem -t m3.large --ebs-vol-size 60 --region=us-east-1 -s 1 launch my-spark-cluster
# Spark standalone cluster started at http://ec2-54-210-189-190.compute-1.amazonaws.com:8080

# to login
./spark-ec2 --key-pair=smallhands --identity-file=smallhands.pem login my-spark-cluster

#Stop the cluster temporarily (still paying for ebs store, not for compute)
./spark-ec2 --region=us-east-1 stop my-spark-cluster
# restart it:
./spark-ec2 -i smallhands.pen  --region=us-east-1 start my-spark-cluster

# destroy instance, including EBS:
./spark-ec2 --region=us-east-1 destroy my-spark-cluster


#----------------------------------------------------------
# install pip, aws commandline tools
#----------------------------------------------------------

# install tmux for windows, etc.
sudo yum install tmux
tmux

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

#-------------------------
#  load json
#-------------------------
cd ebsvol
aws s3 cp  s3://bdif-tweets/sample/sampletweets.tar sample.tar

tar -xvf sample.tar

# to access hadoop, need it's path (there are 2 possibilities)
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


