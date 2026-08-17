# Shared outbound-network helper for the Linux devserver bootstrap scripts.
# Pulled in by the callers with a Go template action naming this file.
# .chezmoitemplates is not deployed, so this exists only inside the generated
# scripts. Do not write that template action literally in this file: the engine
# would parse it and recurse into itself until it hit the depth limit.
#
# fwdproxy exposes two ports and they are not interchangeable:
#   8080  plain HTTP CONNECT proxy
#   8082  terminates TLS and requires the x509 client cert
# A bare CONNECT to 8082 is rejected with curl error 56, which is exactly how
# the first version of this failed. Probe instead of assuming, since the answer
# differs between hosts and can change.

NET_PROXY_ARGS=()
NET_PROXY_URL=""
NET_READY=""

_net_probe() {
    curl -fsS --max-time 15 -o /dev/null "$@" https://github.com 2>/dev/null
}

net_resolve() {
    [ -n "$NET_READY" ] && return 0
    local x509="/var/facebook/credentials/${USER}/x509/${USER}.pem"

    if _net_probe; then
        echo "==> Reaching github.com directly"
        NET_READY=1
        return 0
    fi

    local candidate
    for candidate in http://fwdproxy:8080 http://fwdproxy:8082; do
        if _net_probe --proxy "$candidate"; then
            NET_PROXY_ARGS=(--proxy "$candidate")
            NET_PROXY_URL="$candidate"
            echo "==> Reaching github.com via $candidate"
            NET_READY=1
            return 0
        fi
    done

    if [ -f "$x509" ] && _net_probe --proxy https://fwdproxy:8082 \
            --proxy-cert "$x509" --proxy-key "$x509"; then
        NET_PROXY_ARGS=(--proxy https://fwdproxy:8082
                        --proxy-cert "$x509" --proxy-key "$x509")
        echo "==> Reaching github.com via mTLS https://fwdproxy:8082"
        NET_READY=1
        return 0
    fi

    echo "==> No route to github.com found (tried direct, fwdproxy 8080/8082, mTLS)"
    return 1
}

# net_fetch <url> <dest>
net_fetch() {
    curl -fsSL --max-time 300 ${NET_PROXY_ARGS[@]+"${NET_PROXY_ARGS[@]}"} "$1" -o "$2"
}

# Export proxy vars for child processes that run their own curl (installer
# scripts). Only possible for the plain-URL cases; the mTLS variant needs
# curl-specific flags that no environment variable can express.
net_export_env() {
    if [ -n "$NET_PROXY_URL" ]; then
        export http_proxy="$NET_PROXY_URL"
        export https_proxy="$NET_PROXY_URL"
        export HTTP_PROXY="$NET_PROXY_URL"
        export HTTPS_PROXY="$NET_PROXY_URL"
    fi
}
