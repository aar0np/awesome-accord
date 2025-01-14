# Accord Transaction Examples

This directory contains practical, production-ready examples of using Accord transactions in Apache Cassandra. Each example includes complete schema definitions, transaction implementations, and usage instructions.

## Directory Structure

```
examples/
├── banking/           # Financial transaction examples
├── inventory/         # Inventory management examples
└── user-management/   # User registration and management
```

## Example Categories

### Banking Examples
- Account transfers with overdraft protection
- Multi-currency transactions
- Account creation with constraints

### Inventory Management
- Product inventory tracking
- Shopping cart implementation
- Reservation system

### User Management
- User registration with unique constraints
- Profile updates across multiple tables
- Session management

## Running the Examples

1. Start Accord-enabled Cassandra:
```bash
docker pull pmcfadin/cassandra-accord
docker run -d --name cassandra-accord -p 9042:9042 pmcfadin/cassandra-accord
```

2. Navigate to an example directory:
```bash
cd examples/banking
```

3. Run the setup script:
```bash
./setup.sh
```

4. Follow the example-specific README for detailed instructions.

## Contributing

Give us anyfeedback you have in [Github Discussions](https://github.com/pmcfadin/awesome-accord/)
Want to add an example? See our [contribution guidelines](../CONTRIBUTING.md).

## Getting Help

- Check the [documentation](../docs/)
- Join our [Discord](https://discord.gg/GrRCajJqmQ)
