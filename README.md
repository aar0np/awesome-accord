# Awesome Accord: ACID Transactions in Apache Cassandra

Welcome to the Awesome Accord repository! This guide provides resources and examples for implementing ACID transactions in Apache Cassandra. Learn how to leverage distributed transactions for building reliable applications.

## What's Inside

- **Quick Start with Docker & Podman**: Single-node deployment for immediate testing
- **Lab Environment**: Multi-node cluster setup for development
- **Use Cases & Examples**: Production-ready implementations
- **Learning Resources**: Documentation and best practices

## ⚠️ Warning and Disclaimer ⚠️
Accord is in active development and still a feature branch in the Apasche Cassandra® Repo. You will find bug. What we ask is that you help with a contribution of a bug report. 

You can use the [Github discussions](https://github.com/pmcfadin/awesome-accord/discussions) bug report forum for this or use the Planet Cassandra Discord channel for accord listed below. A bug report should have the folowing:
  - The data model used
  - Actions to reproduce the bug
  - Full stack trace from system.log

If you have suggestions about syntax or improving the overall developer expirience, we want to hear about that to! Add it as a suggestion or feature request using [Github discussions](https://github.com/pmcfadin/awesome-accord/discussions) or let us know in the Planet Cassandra Discord. 

Now, on to the fun!

## Quick Start Options

### Option 1: Docker (Single Node)
```bash
docker pull pmcfadin/cassandra-accord
docker run -d --name cassandra-accord -p 9042:9042 pmcfadin/cassandra-accord
```

### Option 2: Podman (Single Node)
```bash
podman pull pmcfadin/cassandra-accord
podman run -d --name cassandra-accord -p 9042:9042 pmcfadin/cassandra-accord
```

### Option 3: Multi-Node Lab Environment
```bash
brew tap rustyrazorblade/rustyrazorblade
brew install easy-cass-lab
```

## Featured Use Cases

- **Banking Transactions**: Account transfers with ACID guarantees
- **Inventory Management**: Race-free inventory tracking
- **User Management**: Multi-table atomic operations

## Community

- Provide feedback and bug reports in the [repository forum](https://github.com/pmcfadin/awesome-accord/discussions) 
 - [Join our Discord Community](https://discord.gg/GrRCajJqmQ) for discussions and support
- Review our [Contributor Guide](./CONTRIBUTING.md)
- Submit issues and improvements through GitHub

## Repository Structure

```
/
├── docker/            # Docker configuration and setup
├── easy-cass-lab/     # Multi-node testing environment
├── examples/          # Implementation examples
│   ├── banking/       # Financial transaction examples
│   ├── inventory/     # Stock management examples
│   └── user-mgmt/     # User operations examples
├── docs/              # Guides and documentation
└── podman/            # Podman configuration and setup
```

## Documentation

Our [documentation](./docs/README.md) includes:
- Comprehensive setup instructions
- Transaction patterns and implementations
- Performance optimization guides
- Troubleshooting and best practices

## Getting Started

1. Choose your deployment option:
   - [Docker Guide](./docker/README.md)
   - [Easy-Cass-Lab Guide](./easy-cass-lab/README.md)
   - [Podman Guide](./podman/README.md)
2. Follow the [Quick Start Guide](./docs/quickstart.md)
3. Explore [example implementations](./examples/)
4. Connect with our [Discord community](https://discord.gg/GrRCajJqmQ)
5. Feedback! [Github Discussions](https://github.com/pmcfadin/awesome-accord/discussions)

## Example Code

```sql
BEGIN TRANSACTION
    LET fromBalance = (SELECT account_balance 
                      FROM ks.accounts 
                      WHERE account_holder='alice');
    
    IF fromBalance.account_balance >= 20 THEN
        UPDATE ks.accounts 
        SET account_balance -= 20 
        WHERE account_holder='alice';
        
        UPDATE ks.accounts 
        SET account_balance += 20 
        WHERE account_holder='bob';
    END IF
COMMIT TRANSACTION;
```

## License

Apache License 2.0