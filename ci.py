
import subprocess
import json
import os
#print(formatted_output)
os.system("echo python started $date >> /home/ubuntu/cicd/cicd.log")
with open('/home/ubuntu/cicd/config.json', 'r') as file:
    data=json.load(file)
    gitdata = subprocess.Popen(['git', 'ls-remote', data['git_url'], '|', 'grep', data['git_branch']], stdout = subprocess.PIPE)
    output, _ = gitdata.communicate()
    formatted_output=output.decode('ascii').split()[0]
    if data['commit_id'] == formatted_output:
        os.system("echo no new commits  >> /home/ubuntu/cicd/cicd.log")
    else:
        data['commit_id'] = formatted_output
        os.system("echo  new commit found  >> /home/ubuntu/cicd/cicd.log")
        json_dump=json.dumps(data,indent=4)
        with open('/home/ubuntu/cicd/config.json', 'w') as outputfile:
            outputfile.write(json_dump)
        #subprocess.Popen(['sudo', 'sh', 'deployment.sh'], stdout = subprocess.PIPE)
        subprocess.call(['sh', '/home/ubuntu/cicd/cd.sh'])
        os.system("echo  new commit has been deployed  >> /home/ubuntu/cicd/cicd.log")
