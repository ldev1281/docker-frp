FROM debian:bookworm-slim

ARG FRP_VERSION=0.62.1
ENV FRP_VERSION=${FRP_VERSION}

RUN apt-get update \
   && apt-get install -y --no-install-recommends curl ca-certificates \
   && curl -L https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
   | tar -xz --strip-components=1 -C /usr/local/bin frp_${FRP_VERSION}_linux_amd64/frpc \
   && chmod +x /usr/local/bin/frpc \
   && apt-get remove -y curl ca-certificates \
   && apt-get autoremove -y \
   && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
