#!/bin/sh

mkdir 201406
cd 201406

echo "downloading from s3..."
aws s3 cp s3://bdif-tweets2/2014/archiveteam-twitter-stream-2014-06.tar arch2014-06.tar

wait
echo "un-tarring..."
tar -xvf arch2014-06.tar
wait

echo "unzipping"
find . -name "*.json.bz2" -printf '%P\n' | xargs bunzip2

wait
cd ..

python cleanjson.py "/home/ec2-user/ebs/201206" "/home/ec2-user/ebs/cleaned/cleaned_2012_06_"

wait
cd /home/ec2-user/ssd/cleaned/
tar -zcvf cleaned_2012_06.tar.gz cleaned_2012_06_*

echo "done"


