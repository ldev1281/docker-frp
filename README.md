# docker-frp

Docker image for [`frp`](https://github.com/fatedier/frp) client (`frpc`) to expose local services behind NAT/firewalls to the public internet using a reverse proxy tunnel.

This image dynamically generates `frpc.ini` using environment variables.

## Features

- Based on `debian:bookworm-slim`.
- Lightweight and minimal — no unnecessary packages.
- Creates TCP tunnels for HTTP (80) and HTTPS (443) services.

## Usage

### Basic Example

```bash
docker run -d \
  --name frp-client \
  -e FRP_HOST=your.frp.server \
  -e FRP_PORT=7000 \
  -e FRP_TOKEN=your-token \
  -e FRP_LOCAL_HOST=127.0.0.1 \  
  -e FRP_LOCAL_HTTP_PORT=80 \
  -e FRP_REMOTE_HTTP_PORT=80 \
  -e FRP_LOCAL_HTTPS_PORT=443 \
  -e FRP_REMOTE_HTTPS_PORT=443 \
  ghcr.io/ldev1281/docker-frp:latest
```

This starts a container that exposes local ports 80 and 443 to remote ports 80 and 443 on host "your.frp.server"

### Example with Docker Compose (proxy to another service)

```yaml
services:
  proxy-client-caddy:
    image: caddy:latest
    restart: unless-stopped
    networks:
      - proxy-client-private

  frp-client:
    image: ghcr.io/ldev1281/docker-frp:latest
    restart: unless-stopped
    environment:
      FRP_HOST: your.frp.server
      FRP_PORT: 7000
      FRP_TOKEN: your-token
      FRP_LOCAL_HOST: proxy-client-caddy
      FRP_LOCAL_HTTP_PORT: 80
      FRP_REMOTE_HTTP_PORT: 80
      FRP_LOCAL_HTTPS_PORT: 443
      FRP_REMOTE_HTTPS_PORT: 443
    networks:
      - proxy-client-private

networks:
  proxy-client-private:
    driver: bridge
```

In this example, `frp-client` proxies traffic to `proxy-client-caddy` inside the same Docker network.

## Environment Variables

| Variable              | Description                                                     | Required | Default              | Example         |
| --------------------- | --------------------------------------------------------------- | -------- | -------------------- | --------------- |
| FRP_HOST              | Hostname or IP address of the frp server                        | Yes      | —                    | your.frp.server |
| FRP_PORT              | Port number of the frp server                                   | Yes      | —                    | 7000            |
| FRP_TOKEN             | Authentication token for the connection                         | Yes      | —                    | StrongToken     |
| FRP_LOCAL_HOST        | Local host to proxy to                                          | No       | `proxy-client-caddy` | 127.0.0.1       |
| FRP_LOCAL_HTTP_PORT   | Local port of the HTTP service                                  | No       | `80`                  | 8080            |
| FRP_REMOTE_HTTP_PORT  | Remote public port to expose the HTTP service                   | No       | `80`                  | 8080            |
| FRP_LOCAL_HTTPS_PORT  | Local port of the HTTPS service                                 | No       | `443`                 | 8443            |
| FRP_REMOTE_HTTPS_PORT | Remote public port to expose the HTTPS service                  | No       | `443`                 | 8443            |


## License

Licensed under the Prostokvashino License. See [LICENSE.txt](LICENSE.txt) for details.