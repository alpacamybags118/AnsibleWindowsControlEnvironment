# Ansible Windows Control Environment
A docker file that defines an Ansible environment to control Windows nodes.

## Requirements
You will need Docker in order to run this. Also, in order to make the most use out of this container, you should provide the following:

1. hosts file that contain host(s) to connect to
2. windows.yml file to define configuration for connecting to host(s)
3. Playbook(s) that you would like to run against the host(s)

## Host File
Your hosts file should contain a list of IP addresses or host names for each machine you would like to, each separated by a new line. Here is an example:

```
# file: hosts
[windows]
192.168.1.10
192.168.1.11
```

## Windows.yml
This file will define how you connect to the windows hosts, along with the credentials you will use. Here is an example:

```
ansible_user: DOMAIN\ACCOUNT
ansible_password: PASSWORD
ansible_port: 5986
ansible_connection: winrm
ansible_winrm_transport: ntlm
# The following is necessary for Python 2.7.9+ when using default WinRM self-signed certificates:
ansible_winrm_server_cert_validation: ignore
```

## Playbooks
A playbook defines action(s) that you would like to perform on a host. They are housed in a yml file. Here is an example of running ipconfig:

```
- name: test raw module
  hosts: windows
  tasks:
    - name: run ipconfig
      win_command: ipconfig
      register: ipconfig
    - debug: var=ipconfig
 ```
 
 For more information about modules avaliable to use for windows, look here: http://docs.ansible.com/ansible/latest/list_of_windows_modules.html
 
 ## Running the container
 Make sure your docker file, hosts file, windows.yml file, and playbook(s) are in the same directory. Run docker and execute the following command in Powershell:
 
```
docker build -t ansiblewindows -f Dockerfile.dockerfile .
```

Once the container is built, run it by executing this command:

```
docker run -it ansiblewindows
```

Once inside the container, we will need to move a couple files. First, move the hosts file to the windows directory.

```
cp hosts windows/hosts
```

Then move the windows.yml file to the windows/group_vars directory

```
cp windows.yml windows/group_vars/windows.yml
```

You can validate your connection to the hosts by running the following command:

```
ansible windows -i hosts -m win_ping
```
If the command is successful, then you are ready to run your playbook(s). You can do so by running the following command:

```
ansible-playbook playbook.yml -i hosts
```

