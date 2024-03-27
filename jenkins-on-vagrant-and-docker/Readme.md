# VirtualBox Images

VirtualBox saves images, or "boxes," in a specific directory called the "box catalog." The default location for this directory varies depending on your operating system:

- **Windows**: `C:\Users\USERNAME\.vagrant.d\boxes`
- **MacOS/Linux**: `~/.vagrant.d/boxes`

You can use the `vagrant global-status` command to check the status of Vagrant environments and their directories:

```bash
$ vagrant global-status
```

To find out the size of Vagrant boxes, navigate to the box catalog directory and use the du command:

```bash
$ du -hs ~/.vagrant.d/boxes
```

If you encounter an IP address configuration error, ensure that the address falls within the allowed ranges specified in the /etc/vbox/networks.conf file.

To create an alias for the vagrant command, add the following line to your ~/.bashrc file:

```bash
$ echo "alias vg='vagrant'" >> ~/.bashrc
```

Then, source the file to apply the changes:

```bash
$ source ~/.bashrc
```

To SSH into a Vagrant machine, use the vagrant ssh-config command to retrieve the SSH configuration and then SSH using the provided details:

```bash
$ vagrant ssh-config
$ ssh -i PATH_TO_PRIVATE_KEY vagrant@IP_ADDRESS
```

To find out the space taken by a specific box version, navigate to the corresponding directory and use the du command:

```bash
$ du -h PATH_TO_BOX_DIRECTORY
```

Remember to replace placeholders such as USERNAME, IP_ADDRESS, and PATH_TO_PRIVATE_KEY with actual values specific to your setup.

!!! Also, don't forget to add missing files:
 - deployment/backup-files/credentials.xml
 - deployment/backup-files/.ssh/id_ed25519
