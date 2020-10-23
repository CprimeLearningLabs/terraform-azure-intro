# Verifying Your Load-Balanced Cluster

If you want to verify that the load-balanced cluster actually works, you can follow the instructions below to install an HTTP server on the cluster VMs and then use the load balancer public IP in a browser to make an HTTP request.

### Log into Bastion Host

The cluster VMs are in a private subnet and can only be accessed indirectly via the bastion host.

From doing the labs, the public IP of the bastion host should be an output.  You can SSH to to the bastion host as follows (substituting the correct public IP):
```
ssh adminuser@<public-ip>
```

You will be prompted for the password.  Enter the password that was configured in the vm.tf file (or in terraform.tfvars).

*You may also be prompted to confirm that you want to connect. Enter "yes".*

![Cloudshell - ssh into bastion](./images/cs-ssh-public.png "Cloudshell - ssh into bastion")


### Connect to Cluster VMs and Install HTTP Server

From the bastion host, you can SSH to each of the cluster VMs. To SSH to the cluster VMs, you will need their private IPs.  You can find those by viewing the cluster VMs in the Azure Portal, or by using terraform show to see the state of the resources. Note that you want the private IPs not the public IPs of the cluster VMs.

![Azure Portal - VM 0 IP address](./images/az-vm-0-ip.png "Azure Portal - VM 0 IP address")

From the bastion host, ssh using the private IP of the new VMs.  You’ll be prompted for the password.
```
ssh adminuser@<private_ip>
```

![Cloudshell - ssh into VM 0](./images/cs-ssh-private.png "Cloudshell - ssh into VM 0")

On each of the cluster VMs, run the following command to start a simple HTTP server on each VM.
```
sudo apt-get install -y apache2
```

![Cloudshell - apt-get install](./images/cs-apt-get-install.png "Cloudshell - apt-get install")


### Invoke HTTP Request from Browser

You can now go to a browser and use the public IP of the load balancer to hit the HTTP server on the VMs.

![Browser - http load balancer](./images/http-lb.png "Browser - http load balancer")
