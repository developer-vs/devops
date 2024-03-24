**Start Project**

Use the following playbooks to set up the project:

1. **terraform_s3**: Run `setup_s3_bucket.sh`.
2. **terraform**: Run `setup-project.sh`.
3. **ansible**: Run `deploy-docker.yml`.
4. **ansible**: Run `deploy-jenkins.yml`.

After running the playbooks, execute the following scripts from the mapping folder on the local host:
5. **ansible**: Run `/copy_jenkins_files_to_ec2.sh`.
6. **ansible**: Run `restart_jenkins.yml`.

**Additional Instructions:**
- **A. Reload Configuration from Disk:** Navigate to "Manage Jenkins" > "Reload Configuration from Disk" in the Jenkins dashboard to force a reload of job configurations from the filesystem.
- **B. Update Jenkins Login:** After login, ensure to update Jenkins login and password.
- **C. Add SSH Key:** Add the SSH key from `id_ed25519` to the Github plugin.

**Destroy Project**

To destroy the project, run the following scripts:
1. **terraform**: `rm-jenkins-server-tfstate.sh`.
2. **terraform**: `rm-s3-jenkins-server-tfstate.sh`.
3. **terraform_s3**: `echo "y" | remove_s3_bucket.sh`.

Configure AWS credentials by running `aws configure`. Ensure the AWS configuration file (`~/.aws/credentials`) contains the necessary credentials:

```plaintext
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
```


**rsync** is a powerful command-line utility used for syncing files and directories either locally or between two different systems. 

Here's what each option in `rsync -avz -r -e` represents:

- **-a**: Archive mode. This option enables recursion and preserves symbolic links, permissions, timestamps, owner, and group information, making it suitable for backup operations.

- **-v**: Verbose mode. When this option is used, `rsync` provides more detailed output about the files being transferred.

- **-z**: Compression. This option compresses data during transfer, which can reduce the amount of data sent over the network, especially for large files.

- **-r**: Recursive. This option tells `rsync` to recursively transfer directories and their contents.

- **-e**: Specifies the remote shell to use. In this case, it's followed by `"ssh -i /path/to/your/key"`, which means `rsync` will use `ssh` for remote shell connections, and `-i /path/to/your/key` specifies the path to the SSH private key file to use for authentication.

So, `rsync -avz -r -e "ssh -i /path/to/your/key"` means to synchronize files and directories recursively, with archive mode, compression, verbose output, and using SSH for remote shell connections with the specified private key file.

By using `copy_jenkins_files_to_ec2.sh` we will copy Jenkins files from the host to the remote host.

