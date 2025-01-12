# Creating a Cluster in AWS using easy-cass-lab

This guide provides step-by-step instructions for creating a Cassandra cluster on AWS using the easy-cass-lab tool.

## Prerequisites

Before you begin, ensure that you have either built or installed easy-cass-lab via homebrew. Follow the [Homebrew installation
instructions](https://rustyrazorblade.com/post/2024/easy-cass-lab-homebrew/) if you haven't done so already, 
or build from source following the instructions in the [repo](https://github.com/rustyrazorblade/easy-cass-lab).

## QuickStart

First, create a directory where you want to set up your Cassandra environment and navigate into it:
```shell
mkdir accord-test
cd accord-test
```

Use easy-cass-lab to provision instances on AWS:

Initialize the cluster with three coordinator nodes and one seed node:
```shell
easy-cass-lab init -c 3 -s 1 accord-test
```

Start the provisioning process:
```shell
easy-cass-lab up
```

This will set up the necessary AWS infrastructure for your Cassandra cluster.

To ensure you're using a specific version with the Accord build, execute:

```shell
easy-cass-lab use accord
```

Then, start the cluster:

```shell
easy-cass-lab start
```

Your Cassandra cluster is now up and running on AWS. You can begin interacting with it for testing or development purposes.

To load the cluster's state into your shell's environment, run the following:

```shell
source env.sh
```

Either of the following two commands can SSH to the first node:

```shell
ssh cassandra0
c0
```

You can also SSH to the stress0 node:

```shell
ssh stress0
s0
```

You can upload files to the stress node by doing the following:

```shell
scp path/to/file stress0:
```


For further customization or troubleshooting, refer to 
the [easy-cass-lab documentation](https://github.com/rustyrazorblade/easy-cass-lab) 
and explore additional configurations as needed.

