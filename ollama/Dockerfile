# Use the exact same base image specified in your compose file
FROM ollama/ollama:latest

RUN apt update -y && apt upgrade -y && apt install -y curl 

# Embed the healthcheck logic directly into the image metadata
# HEALTHCHECK --interval=15s --timeout=30s --start-period=45s --retries=10 \
#   CMD ["curl", "-f", "http://ollama:11434"]

# Define the data directory as a placeholder volume footprint
VOLUME ["/root/.ollama"]

# Document the default internal container port
EXPOSE 11434
