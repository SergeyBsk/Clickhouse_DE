docker run -d \
    --name clickhouse-server \
    --ulimit nofile=262144:262144 \
    -p 8123:8123 \
    -p 9000:9000 \
    -v $(pwd)/Task2/data:/var/lib/clickhouse \
    -v $(pwd)/Task2/logs:/var/log/clickhouse-server \
    -v $(pwd)/Task2/config:/etc/clickhouse-server/config.d \
    -v $(pwd)/Task2/users:/etc/clickhouse-server/users.d \
    clickhouse/clickhouse-server
