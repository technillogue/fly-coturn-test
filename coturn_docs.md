from https://github.com/coturn/coturn/blob/master/docker/coturn/README.md

## What is Coturn TURN server?

The TURN Server is a VoIP media traffic NAT traversal server and gateway. It can be used as a general-purpose network traffic TURN server and gateway, too.

> [github.com/coturn/coturn](https://github.com/coturn/coturn)




## How to use this image

To run Coturn TURN server just start the container: 
```bash
docker run -d -p 3478:3478 -p 3478:3478/udp -p 5349:5349 -p 5349:5349/udp -p 49152-65535:49152-65535/udp coturn/coturn
```


### Why so many ports opened?

As per [RFC 5766 Section 6.2], these are the ports that the TURN server will use to exchange media.

You can change them with `min-port` and `max-port` Coturn configuration options:
```bash
docker run -d -p 3478:3478 -p 3478:3478/udp -p 5349:5349 -p 5349:5349/udp -p 49160-49200:49160-49200/udp \
       coturn/coturn --min-port=49160 --max-port=49200
```

Or just use the host network directly (__recommended__, as Docker [performs badly with large port ranges][7]):
```bash
docker run -d --network=host coturn/coturn
```


### Configuration

By default, default Coturn configuration and CLI options provided in the `CMD` [Dockerfile][d1] instruction are used.

1. You may either specify your own configuration file instead.

    ```bash
    docker run -d --network=host \
               -v $(pwd)/my.conf:/etc/coturn/turnserver.conf \
           coturn/coturn
    ```

2. Or specify command line options directly.

    ```bash
    docker run -d --network=host coturn/coturn \
               -n --log-file=stdout \
               --min-port=49160 --max-port=49200 \
               --lt-cred-mech --fingerprint \
               --no-multicast-peers --no-cli \
               --no-tlsv1 --no-tlsv1_1 \
               --realm=my.realm.org \  
    ```
    
3. Or even specify another configuration file.

    ```bash
    docker run -d --network=host  \
               -v $(pwd)/my.conf:/my/coturn.conf \
           coturn/coturn -c /my/coturn.conf
    ```

#### Automatic detection of external IP

`detect-external-ip` binary may be used to automatically detect external IP of TURN server in runtime.
To add ` --external-ip=<detected external IP>` using `detect-external-ip` as argument for `turnserver`, set envronment variable `DETECT_EXTERNAL_IP`. Also, environment variables `DETECT_RELAY_IP`, `DETECT_EXTERNAL_IPV6` and `DETECT_RELAY_IPV6` can be used for adding arguments ` --external-ip=<detected external IP>` or ` --relay-ip=<detected external IP>`.
It's okay to use it multiple times (the value will be evaluated only once).
```bash
docker run -d --network=host \
           -e DETECT_EXTERNAL_IP=yes \
           -e DETECT_RELAY_IP=yes \
           coturn/coturn \
           -n --log-file=stdout
```

By default, [IPv4] address is discovered. In case you need an [IPv6] one, specify the `--ipv6` flag:
```bash
docker run -d --network=host coturn/coturn \
           -n --log-file=stdout \
           --external-ip='$(detect-external-ip --ipv6)' \
           --relay-ip='$(detect-external-ip --ipv6)'
```
