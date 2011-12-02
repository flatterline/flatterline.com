--- 
author: Chris Chandler
excerpt:
  Have you ever used an unsecured wireless connection at a coffeeshop? Find
  out how you're putting your data at risk and the steps you can take to
  protect yourself.
layout: post
title: Disposable proxy for secure coffee shop browsing
tags: 
- business
- technology
---

If you are a highly mobile laptop user, chances are you work out of a lot of varying public locations such as coffee shops, libraries, and just about anywhere that has public wifi. Are you concerned about the privacy of your data?If you're like me, and our clients, you're very concerned. Applications like [tcpflow](http://www.circlemud.org/~jelson/software/tcpflow/) and [Wireshark](http://www.wireshark.org/) are not only particularly effective at grabbing content from the network, they also happen to be readily available.

**Here's a very simple scheme to leverage the inexpensive power of Amazon's EC2 to create a disposable, secure proxy.**

### Getting started

You will need the following to make this recipe work:

*   Amazon AWS account

*   A Ubuntu-based Amazon AMI with keypair (we are using publicami-7cfd1a15 for this article)

*   An EC2 security group allowing a minimum of port 22 for SSH

To start, launch a small instance of your AMI of choice. Once again, we prefer Ubuntu so most of this article is going to be Ubuntu-centric. This instance will need to be setup with whatever key pair you plan on using as well as be placed in the security group that allows SSH access. If you need help with this the Amazon [AWS console](http://console.aws.amazon.com/) is particularly useful.

### Putting the pieces together

Once the instance is made available ssh to your newly created instance.

    ssh -i identity_file -L 3128:localhost:3128 root@public_ec2_domain_name

The noteworthy addition to the previous line is `-L 3128:localhost:3128`. This addition to the SSH command will open port 3128 locally and forward all traffic to the remote port 3128 across the open SSH connection.

Once the connection is open you will need to install a proxy, we prefer [squid](http://www.squid-cache.org/). Squid can be installed through the following command:

    aptitude update
    aptitude install squid

The last remaining step is to configure your browser of choice to use proxy `localhost:3128`.

The final result is **all local HTTP traffic will be relayed across local port 3128 across the encrypted SSH tunnel to the 10 cents / hour remote server**. From there it will go out to the internet at large away from the prying eyes of nefarious coffee shop patrons. **Keep the SSH connection open for as long as you need access to the proxy.**

### Cleaning up after yourself

When your done at the coffee shop feel free to decommission the AMI instance and you're done. The machine will go away with all records of the proxy's cache.

*If you're looking for a solution to more than just your HTTP traffic you have options such as OpenVPN. Look for an article from us soon.*
