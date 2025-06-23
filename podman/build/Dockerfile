FROM openjdk:17-jdk-slim

# Install required packages
RUN apt-get update && apt-get install -y procps python3 python3-pip

# Install Python Cassandra driver
RUN pip3 install --no-cache-dir cassandra-driver

# Copy the Cassandra build into the container
COPY cassandra /opt/cassandra

# Set environment variables
ENV MAX_HEAP_SIZE=512M
ENV HEAP_NEWSIZE=100M

# Create a non-root user and set permissions
RUN useradd -ms /bin/bash cassandra-user
RUN chown -R cassandra-user:cassandra-user /opt/cassandra

# Switch to non-root user
USER cassandra-user

# Set the working directory
WORKDIR /opt/cassandra

# Expose ports
EXPOSE 7000 7001 7199 9042 9160

# Run Cassandra
ENTRYPOINT ["./bin/cassandra", "-f"]
