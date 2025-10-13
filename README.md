# KaliGuard

KaliGuard is a Dockerized Kali environment routed through an external VPN tunnel using Gluetun. It is intended for privacy-focused penetration testing and reconnaissance.

## Getting started

`$ git clone github.com/Perdyx/kaliguard.git`

## Configuration

### Setting the root password

The ROOT_PASSWORD environment variable sets the root user password inside the KaliGuard container.

## VPN provider setup

Gluetun supports a variety of VPN providers. Each provider has specific environment variables that need to be configured properly.

Refer to the official Gluetun setup guide for your VPN provider: https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers

### Shared directories

To share files or directories between your host and the KaliGuard container, add volume mounts to the kaliguard service in docker-compose.yaml:

```
volumes:
  - ./host/path:/container/path
```

### Changing the default ports or opening new ones

Because the kaliguard container uses:

network_mode: "service:gluetun"

it shares the network stack of the gluetun container. As a result, all port mappings must be defined on the gluetun container.

For example, to change the default SSH port, change the left half of the port configuration:

```
gluetun:
  ports:
    - "<port>:22"
```

## Running the environment

### Building the KaliGuard image

To build the KaliGuard Docker image locally:

cd app
docker build -t kaliguard:latest .

### Docker Compose

To start the environment in the foreground:

`$ docker compose up`

To run in detached mode (background):

`$ docker compose up -d`

To stop and remove containers:

`$ docker compose down`

## Art credits

- https://emojicombos.com/oni-ascii-art