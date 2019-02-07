# docker-ssh-agent

Docker ssh-agent lets you in a container.

## Usage

Usage is as simple as 1-2-3!

### Run a long-lived container named ssh-agent

```bash
docker run -d --name=ssh-agent continuul/ssh-agent
```

### Add your ssh keys

```bash
docker run --rm --volumes-from=ssh-agent -v ~/.ssh:/root/.ssh -it ssh-agent ssh-add /root/.ssh/id_rsa
```

### Access from other containers

## Examples

### List keys