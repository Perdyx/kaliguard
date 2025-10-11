# KaliGuard

## Configuration

Create a `.env` file in the project root with the following environment variables:

```env
ROOT_PASSWORD=<your-root-password>
SSH_PORT=<port>
WIREGUARD_PRIVATE_KEY=<your_private_key>
SERVER_COUNTRIES=<comma,separated,list,of,countries>
FREE_ONLY=<true/false>
```

## Running the Environment

Start the environment in the foreground:

```bash
$ docker compose up
```

To stop and remove the environment when running in the foreground, press `Ctrl + C`.

Alternatively, to run in detached mode (recommended for server deployments):

```bash
$ docker compose up -d
```

## Customization

### Opening ports on the kaliguard container

Ports can be opened on the kaliguard container by adding them to gluetun container.

### Enabling shared directories

In docker-compose.yaml, file and directory mounts can be added to the kaliguard container as needed.

### Building the Docker Image

To build the Docker image locally, run:

```bash
$ cd app
$ docker build -t kaliguard:latest .
```

## Troubleshooting

### SSH Key Regeneration (Optional)

If you need to regenerate SSH keys for localhost access, use:

```bash
$ ssh-keygen -R "[localhost]:<port>"
```

Replace `<port>` with the actual port used for the connection.

## Art Credits

- https://emojicombos.com/oni-ascii-art