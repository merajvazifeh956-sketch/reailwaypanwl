FROM alpine:3.19

RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# 3x-ui — web panel for Xray-core (supports VLESS / VMess / Trojan /
# Shadowsocks / Reality / WS / gRPC / WireGuard / Hysteria2 etc).
# On Railway only the TCP-based protocols can actually pass through the
# platform proxy (Railway exposes HTTP + TCP; there is no public UDP).
ENV XUI_VERSION=v3.4.2

RUN mkdir -p /etc/x-ui /var/log/x-ui \
    && curl -fsSL "https://github.com/mhsanaei/3x-ui/releases/download/${XUI_VERSION}/x-ui-linux-amd64.tar.gz" \
         -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /opt \
    && mv /opt/x-ui /opt/app \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /opt/app/x-ui

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2053 443

CMD ["/start.sh"]
