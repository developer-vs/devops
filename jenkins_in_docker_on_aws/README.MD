**Start Project**

1. **terraform_s3**: `setup_s3_bucket.sh`
2. **terraform**: `setup-project.sh`
3. **ansible**: `deploy-docker.yml`
4. **ansible**: `deploy-jenkins.yml`
5. **ansible**: `/copy_jenkins_files_to_ec2.sh` 
6. **ansible**: `restart_jenkins.yml`

A. Reload Configuration from Disk: 
In the Jenkins dashboard, navigate to "Manage Jenkins" > "Reload Configuration from Disk". 
This will force Jenkins to reload the job configurations from the filesystem.

B. After login, update Jenkins login and password!!!

C. Add SSH key from `id_ed25519` to the Github plugin.

**Destroy Project**

1. **terraform**: `rm-jenkins-server-tfstate.sh`
2. **terraform**: `rm-s3-jenkins-server-tfstate.sh`
3. **terraform_s3**: `echo "y" | remove_s3_bucket.sh`

**rsync** is a powerful command-line utility used for syncing files and directories either locally or between two different systems. 

Here's what each option in `rsync -avz -r -e` represents:

- **-a**: Archive mode. This option enables recursion and preserves symbolic links, permissions, timestamps, owner, and group information, making it suitable for backup operations.

- **-v**: Verbose mode. When this option is used, `rsync` provides more detailed output about the files being transferred.

- **-z**: Compression. This option compresses data during transfer, which can reduce the amount of data sent over the network, especially for large files.

- **-r**: Recursive. This option tells `rsync` to recursively transfer directories and their contents.

- **-e**: Specifies the remote shell to use. In this case, it's followed by `"ssh -i /path/to/your/key"`, which means `rsync` will use `ssh` for remote shell connections, and `-i /path/to/your/key` specifies the path to the SSH private key file to use for authentication.

So, `rsync -avz -r -e "ssh -i /path/to/your/key"` means to synchronize files and directories recursively, with archive mode, compression, verbose output, and using SSH for remote shell connections with the specified private key file.

By using `copy_jenkins_files_to_ec2.sh` we will copy Jenkins files from the host to the remote host.

