# Podman Setup for Accord-Enabled Cassandra

Get started with ACID transactions in Cassandra using our pre-configured image. This guide covers both single-node and multi-node setups.

## Quick Start (Single Node)

```bash
# Pull the latest image
podman pull pmcfadin/cassandra-accord

# Start a container
podman run -d \
  --name cassandra-accord \
  -p 9042:9042 \
  pmcfadin/cassandra-accord

# Connect using cqlsh
podman exec -it cassandra-accord ./bin/cqlsh
```

## Environment Variables

Customize your Cassandra instance with these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| MAX_HEAP_SIZE | 512M | Maximum heap size |
| HEAP_NEWSIZE | 100M | New generation heap size |

Example with custom memory settings:
```bash
podman run -d \
  --name cassandra-accord \
  -p 9042:9042 \
  -e MAX_HEAP_SIZE=1G \
  -e HEAP_NEWSIZE=200M \
  pmcfadin/cassandra-accord
```

## Data Persistence

Mount volumes to persist your data:

```bash
podman run -d \
  --name cassandra-accord \
  -p 9042:9042 \
  -v $(pwd)/cassandra-data:/opt/cassandra/data \
  pmcfadin/cassandra-accord
```

## Multi-Node Setup

Use our docker-compose.yml to run a multi-node cluster:

```bash
# Start a 3-node cluster
podman-compose up -d

# Scale to more nodes
podman-compose up -d --scale cassandra=3
```

## 🔍 Ports

| Port | Description |
|------|-------------|
| 9042 | CQL native transport |
| 7000 | Inter-node communication |
| 7001 | TLS inter-node communication |
| 7199 | JMX |

## Advanced Configuration

### Custom cassandra.yaml

1. Extract the default configuration:
```bash
podman cp cassandra-accord:/opt/cassandra/conf/cassandra.yaml ./cassandra.yaml
```

2. Start with custom config:
```bash
podman run -d \
  --name cassandra-accord \
  -p 9042:9042 \
  -v $(pwd)/cassandra.yaml:/opt/cassandra/conf/cassandra.yaml \
  pmcfadin/cassandra-accord
```

## Trying New Syntax

Try the examples after connecting and see how the new transaction syntax works. 


## Need Help?
- Check out the [Github Discussions](https://github.com/pmcfadin/awesome-accord/) in the repository
- Join our [Discord](https://discord.gg/GrRCajJqmQ) for real-time support
- Check the [Troubleshooting Guide](../docs/troubleshooting.md)
- Report issues on GitHub