#!/usr/bin/python
import sys
import commands
sys.path.append(sys.path[0]+'/../libs')
import cc_job_logger
from datetime import datetime
import ConfigParser

start_time = datetime.now()
conf=ConfigParser.ConfigParser()
conf.read(sys.path[0]+"/../conf/default.conf")

ftp_server = conf.get('qlikview','ftp_server')
ftp_user = conf.get('qlikview', 'ftp_user')
ftp_password = conf.get('qlikview', 'ftp_password')
s3_path = conf.get('pack_qty','s3_data')
if s3_path[-1] != '/':
	s3_path = s3_path + '/'

sns_region = conf.get('sns','region')
sns_topic = conf.get('sns','topic')

command = 'sh ' + sys.path[0] + '/pack_qty.sh ' + ftp_server + ' ' + ftp_user + ' ' + ftp_password + ' ' + s3_path + ' ' + sns_region + ' ' + sns_topic + ' > ' + sys.path[0] + '/pack_qty.out'

(status, output)=commands.getstatusoutput(command)

end_time = datetime.now()
if status == 0:
	cc_job_logger.insert_log('PACK_QTY', start_time, end_time, 'SUCCESS')
else:
	cc_job_logger.insert_log('PACK_QTY', start_time, end_time, 'FAILED', '{"error":"' + output + '"}')

