---------------------
load json
------------------

see tweets_aws.scala...


aws s3 cp  s3://bdif-tweets/cleaned/2013-01/clean-tweets-p1.tar.bz2 p1.tar.bz2

bunzip2 p1.tar.bz2
tar -xvf p1.tar
hadoop fs -mkdir csv
hadoop fs -ls
hadoop fs -put *.csv csv/

---------------------
pip
------------------
#http://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-with-pip
curl -O https://bootstrap.pypa.io/get-pip.py
sudo python27 get-pip.py
pip install awscli

# Need ~/bin to be in PATH var for the symlink to work:
# See if $PATH contains ~/bin (if not, output is null)
echo $PATH | grep ~/bin     
export PATH=~/bin:$PATH

aws configure
# enter key ID and access Key.