# Supported tags and respective `Dockerfile` links

- [`latest` (*Dockerfile*)][5]

# Quick reference

- **Where to file issues**:   
    [https://github.com/nuodb/docker-ssh-agent/issues][2]

- **Maintained by**:   
    [NuoDB][0]

- **Source of this description**:  
    [docs repo's `docker-ssh-agent/` directory][3] ([history][4])

- **Supported Docker versions**:   
    [the latest release](https://github.com/docker/docker-ce/releases/latest) (down to 1.6 on a best-effort basis)

# What is ssh-agent?

Docker ssh-agent lets you run ssh-agent and ssh client commands in a container. It allows you to mount and register keys using ssh-add in a container, then let those credentials persist so long as the container is running. Once the container exits, the keys are automatically destroyed.

The benefit of using the container is to provide host access within clusters when nodes are on a private network, namely giving access to private nodes in Kubernetes clusters (managed or otherwise) running on Amazon, Azure, or Google.

For more information, please see:

- [Project on GitHub][1]

<img src="https://www.nuodb.com/sites/all/themes/nuodb/logo.svg" alt="drawing" width="200px"/>

# How to use this image

Running the container with no arguments will give you a running ssh-agent process running with typical Linux settings.

## Environment Variables

The container exposes the following environment variables, and default values:

- **SSH_DIR** /.ssh
- **SOCKET_DIR** /.ssh-agent
- **SSH_AUTH_SOCK** ${SOCKET_DIR}/socket
- **SSH_AUTH_PROXY_SOCK** ${SOCKET_DIR}/proxy-socket

## Volumes

The container exposes `VOLUME ${SOCKET_DIR}`, which is a path to the Unix Domain Socket associated with the ssh-agent; the Unix Domain Socket may be shared between containers in order to run the `ssh-add` command.

## Run a long-lived container named ssh-agent

To run an ssh-agent in Docker:

```bash
docker run -d --name=ssh-agent continuul/ssh-agent
```

To run an ssh-agent in a Kubernetes cluster:

```bash
$ kubectl apply -f pod.yaml
pod/ssh-agent created

$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
ssh-agent                   1/1       Running   0          5s
```

## Add your ssh keys

To add your ssh keys to a running container, simply mount the same volume provided by the ssh-agent container, and run the ssh-add command:

```bash
docker run --rm --volumes-from=ssh-agent -v ~/.ssh:/root/.ssh -it ssh-agent \
    ssh-add /root/.ssh/id_rsa
```

In Kubernetes the commands are slightly different:

```bash
$ kubectl cp ~/.ssh/id_rsa_azure ssh-agent:/id_rsa_azure
$ kubectl exec -it ssh-agent -- /bin/bash
bash-4.4# ssh-add id_rsa_azure 
Identity added: id_rsa_azure (user@myhost)
```

### Azure

If you're on Azure, the commands to sprinkle SSH keys across each of your worker nodes is:

```bash
az aks show --resource-group myResourceGroup \
    --name myAKSCluster --query nodeResourceGroup -o tsv

az vm list --resource-group MC_myResourceGroup_myAKSCluster_eastus \
    -o table

az vm user update \
    --resource-group MC_myResourceGroup_myAKSCluster_eastus \
    --name aks-nodepool1-79590246-0 \
    --username azureuser \
    --ssh-key-value ~/.ssh/id_rsa.pub
```

## List your keys

In raw Docker:

```bash
docker run --rm -it -v ssh:/ssh -e SSH_AUTH_SOCK=/ssh/auth/sock ubuntu \
    /bin/bash -c "apt-get update && apt-get install -y openssh-client && ssh-add -l"
```

Or in Kubernetes:

```bash
$ ssh-add -l
4096 askjhjk34h25243jk5kjhasfhj you@mylaptop (RSA)

```

# License

View [license information][6] for the software contained in this image.

[0]: https://www.nuodb.com/
[1]: https://github.com/nuodb/docker-ssh-agent
[2]: https://github.com/nuodb/docker-ssh-agent/issues
[3]: https://github.com/nuodb/docker-ssh-agent/blob/master/README.md
[4]: https://github.com/nuodb/docker-ssh-agent/commits/master/
[5]: https://github.com/nuodb/docker-ssh-agent/blob/master/Dockerfile
[6]: https://github.com/nuodb/docker-ssh-agent/blob/master/LICENSE