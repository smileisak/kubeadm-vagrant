# kubeadm-vagrant

[![Build Status](https://travis-ci.org/smileisak/kubeadm_vagrant.svg?branch=master)](https://travis-ci.org/smileisak/kubeadm_vagrant)

This project bootstraps an already configured [Vagrant]() instances to practice Kubernetes cluster installation using kubeadm.

## TL;DR;

```bash
$  git clone https://github.com/smileisak/kubeadm_vagrant.git
$  vagrant up 
```

By default this project bootstraps one master node and one worker node. You can override this behaviour by adding additional instance in nodes list.


```ruby
nodes = [
  { :hostname => 'c1',  :ip => '172.16.66.2', :ram => 1024 },
  { :hostname => 'w1',  :ip => '172.16.66.3', :ram => 1024 },
]
```


## Prerequisites

- Vagrant 1.8 +

## Installing the Chart

To run instances

```bash
$ vagrant up
```

The command creates 2 centos/7 instances and provision it with:

- Docker
- Kubectl
- kubeadm
- kubelet

## Provision instances

To provision instance run :

```bash
$ vagrant provision
```
By defaut when you run `vagrant up` it provision all instances.


## Remove instances

To remove intances

```bash
$ vagrant destroy -f
```

The command removes all instances.
