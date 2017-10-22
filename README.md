# kubeadm-vagrant

[![Build Status](https://travis-ci.org/smileisak/kubeadm_vagrant.svg?branch=master)](https://travis-ci.org/smileisak/kubeadm_vagrant)

This project bootstraps an already configured [Vagrant]() instances to practice Kubernetes cluster installation using kubeadm.

## TL;DR;

```bash
$  git clone https://github.com/smileisak/kubeadm_vagrant.git
$ cd kubeadm_vagrant && ./run.sh --full
```

By default this project bootstraps one master node and one worker node. You can override this behaviour by adding additional instances in nodes list.


```ruby
nodes = [
  { :hostname => 'c1', :ram => 1024 },
  { :hostname => 'w1',  :ram => 1024 },
]
```


## Prerequisites

- Vagrant 1.8 +
- Linux server

## Running instances

To run instances

```bash
$ ./run.sh --full
```

The command creates 2 centos/7 instances and provision it with:

- Docker
- Kubectl
- kubeadm
- kubelet

For using vagrant on one or multiple machines with bridged interface (public_network and ports accessible) all machines must have 1st interface as the **bridged** interface (so k8s processes will bind automatically to it). This is done thanks to @ReSearchITEng work.

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
