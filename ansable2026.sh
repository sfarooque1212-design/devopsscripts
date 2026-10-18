sudo dnf install ansible-core -y
sudo dnf install python3 python3-pip python3-devel -y

EC2 instance running Amazon Linux 2023 
dnf install ansible -y
sudo dnf install python3 python3-pip python3-devel -y


Ansible Setup and SSH Authentication Guide (RHEL 10)
1. Install Ansible Core on Control Node (Master)
Update system packages:
sudo dnf upgrade -y

Install Ansible Core:
sudo dnf install -y ansible-core

Verify installation:
ansible --version

Test local ping:
ansible localhost -m ping

2. Configure Target Node (Client) for SSH Copy
On the TARGET/CLIENT node, allow Password Authentication and Root Login.

Check for conflicting settings across SSH config files:
grep -rn "PasswordAuthentication" /etc/ssh/sshd_config*

Edit the main SSH configuration file:
vi /etc/ssh/sshd_config

Set: PermitRootLogin yes

Set: PasswordAuthentication yes

Ensure no bottom lines override this to "PasswordAuthentication no"

Edit the Cloud-Init override file (if present):
vi /etc/ssh/sshd_config.d/50-cloud-init.conf

Set: PasswordAuthentication yes

Set: PermitRootLogin yes

Restart SSH service to apply changes:
systemctl restart sshd

3. Generate and Copy SSH Keys from Master to Client
On the MASTER node:

Generate SSH Key Pair:
ssh-keygen -t ed25519
(Press Enter to accept defaults and no passphrase)

Copy SSH Public Key to Target Node:
ssh-copy-id root@<CLIENT_IP>
(Enter root password when prompted)

Test Passwordless SSH Login:
ssh root@<CLIENT_IP>

4. Test Ansible Connectivity to Target Node
On the MASTER node:

Create an inventory file (inventory.ini):
vi inventory.ini

Add target host details:
[servers]
<CLIENT_IP> ansible_user=root

Run ping module against target node:
ansible all -i inventory.ini -m ping

Expected Output:
<CLIENT_IP> | SUCCESS => {
"changed": false,
"ping": "pong"
}
