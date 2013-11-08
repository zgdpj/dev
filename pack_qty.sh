#!/bin/sh

# Connect to qlikview ftp
#dir=`pwd`/`dirname $0`
dir=`dirname $0`
LOCAL_PATH="${dir}"

SERVER=$1
USERNAME=$2
PASSWORD=$3


echo $LOCAL_PATH

cd $LOCAL_PATH/data

# login to remote server
lftp -u $USERNAME,$PASSWORD ftp://$SERVER <<EOF
user $USERNAME $PASSWORD
get PACK_QTY.csv
bye
EOF

gzip --force PACK_QTY.csv
# put pack_qty file to s3
s3_path=$4
s3cmd put PACK_QTY.csv.gz $s3_path

cd $LOCAL_PATH

# copy pack_qty file to dtm_prod.pack_qty
sh $LOCAL_PATH/../exec_redshift.sh $LOCAL_PATH/sql/copy.sql Photo01$


#time=`date '+%m/%d/%Y %H:%M'`
#su - bi.admin -c "cat /home/mmezin/jpan/pythonScript/pack_qty/pack_qty.out | mail -s \"[RedShift] $time PACK_QTY is imported \" -- bi.admin@photobox.com"
msg=`cat pack_qty.out`
region=$5
topic=$6
/usr/local/bin/aws sns publish --region $region --topic-arn $topic --subject  "[RedShift] $time PACK_QTY is imported" --message "$msg"
