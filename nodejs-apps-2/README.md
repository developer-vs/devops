# DevOps_jenkins_tf_ans_node_js_setup
terraform + ansible + nodejs app infra an setup

This repo contains multiple tech insights. 
The primary purpose is to show off the Jenkins + Terraform + Ansible + NodeJs combination. 

Prerequisites to make it work:

0. Understanding of 
  `Groovy`
  `HSL` `(*.tf)`
  `Ansible` `(YAML)`
  
1. Jenkins with access to your AWS account and cloud
   It could be AWS Cloud-based EC2 instance with proper role and permissions attached
     or
   It could be Jenkins running on your localhost with aws credentials set to provide access to:
     1. EC2
     2. Role
     3. S3
2. The second part involves understanding of Jenkins pipeline and how to set them up using Jenkins `groovy` language
3. The app's directories are used as open-source products available in public repositories on the web. without any commercial or any other intent. Any improvements to the app desighn highly encouraged and appreciated.
     The apps in question:
         Battleships
         DadJokes generator 
         
4. How to use pm2 (run on ec2)

$ pm2 list
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 0  │ battleships        │ fork     │ 0    │ online    │ 0%       │ 50.8mb   │
│ 1  │ dadjokes           │ fork     │ 0    │ online    │ 0%       │ 48.6mb   │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴───────---

$ pm2 logs 0
[TAILING] Tailing last 15 lines for [0] process (change the value with --lines option)
/home/ubuntu/.pm2/logs/battleships-error.log last 15 lines:
/home/ubuntu/.pm2/logs/battleships-out.log last 15 lines:
0|battlesh | Server running on port 3000

$ pm2 logs 1
[TAILING] Tailing last 15 lines for [1] process (change the value with --lines option)
/home/ubuntu/.pm2/logs/dadjokes-error.log last 15 lines:
/home/ubuntu/.pm2/logs/dadjokes-out.log last 15 lines:
1|dadjokes | dadjokes server started on port: 3001

$ pm2 describe 0
 Describing process with id 0 - name battleships 
┌───────────────────┬──────────────────────────────────────────────┐
│ status            │ online                                       │
│ name              │ battleships                                  │
│ namespace         │ default                                      │
│ version           │ 1.0.0                                        │
│ restarts          │ 0                                            │
│ uptime            │ 4m                                           │
│ script path       │ /opt/battleships_app/battleships/server.js   │
│ script args       │ N/A                                          │
│ error log path    │ /home/ubuntu/.pm2/logs/battleships-error.log │
│ out log path      │ /home/ubuntu/.pm2/logs/battleships-out.log   │
│ pid path          │ /home/ubuntu/.pm2/pids/battleships-0.pid     │
│ interpreter       │ node                                         │
│ interpreter args  │ N/A                                          │
│ script id         │ 0                                            │
│ exec cwd          │ /opt/battleships_app/battleships             │
│ exec mode         │ fork_mode                                    │
│ node.js version   │ 16.20.2                                      │
│ node env          │ N/A                                          │
│ watch & reload    │ ✘                                           │
│ unstable restarts │ 0                                            │





