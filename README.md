# docker-frp

Docker image for [`frp`](https://github.com/fatedier/frp) client (`frpc`) to expose local services behind NAT/firewalls to the public internet using a reverse proxy tunnel.

This image dynamically generates `frpc.ini` using environment variables.

## Features

- Based on debian:bookworm-slim.
- Lightweight and minimal — no unnecessary packages.

## Usage

### Basic Example

```bash
docker run -d \
  --name frp-client \
  -e FRP_HOST=your.frp.server \
  -e FRP_PORT=7000 \
  -e FRP_TOKEN=your-token \
  -e FRP_LOCAL_HTTP_PORT=80 \
  -e FRP_REMOTE_HTTP_PORT=80 \
  -e FRP_LOCAL_HTTPS_PORT=443 \
  -e FRP_REMOTE_HTTPS_PORT=443 \  
  ghcr.io/ldev1281/docker-frp:latest
```

This starts a container that exposes local ports 80 and 443 to remote ports 80 and 443 on host "your.frp.server"

### With Docker Compose

```yaml
services:
  frp-client:
    image: ghcr.io/ldev1281/docker-frp:latest
    restart: unless-stopped
    environment:
      FRP_HOST: your.frp.server
      FRP_PORT: 7000
      FRP_TOKEN: your-token
      FRP_LOCAL_HTTP_PORT: 80
      FRP_REMOTE_HTTP_PORT: 80
      FRP_LOCAL_HTTPS_PORT: 443
      FRP_REMOTE_HTTPS_PORT: 443
```

## Environment Variables

| Variable              | Description                                                     | Required | Example         |
| --------------------- | --------------------------------------------------------------- | -------- | --------------- |
| FRP_HOST              | Hostname or IP address of the frp server                        | Yes      | your.frp.server |
| FRP_PORT              | Port number of the frp server                                   | Yes      | 7000            |
| FRP_TOKEN             | Authentication token for the connection                         | Yes      | StrongToken     |
| FRP_LOCAL_HOST        | Local host to proxy to (default: `127.0.0.1`)                   | No       | 127.0.0.1       |
| FRP_LOCAL_HTTP_PORT   | Local port of the HTTP service (default: `80`)                  | No       | 80              |
| FRP_REMOTE_HTTP_PORT  | Remote public port to expose the HTTP service (default: `80`)   | No       | 80              |
| FRP_LOCAL_HTTPS_PORT  | Local port of the HTTPS service (default: `443`)                | No       | 443             |
| FRP_REMOTE_HTTPS_PORT | Remote public port to expose the HTTPS service (default: `443`) | No       | 443             |


## License

Licensed under the Prostokvashino License. See [LICENSE.txt](LICENSE.txt) for details.