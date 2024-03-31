FROM coturn/coturn

# Expose the necessary ports
EXPOSE 3478 3478/udp 5349 5349/udp 49152-65535/udp

# Specify your Coturn configuration file
COPY coturn.conf /etc/coturn/turnserver.conf

# Run the Coturn server with your configuration
CMD ["-c", "/etc/coturn/turnserver.conf"]
