FROM alpine:3.14

RUN wget https://download.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-amd64.tar.gz

RUN tar xvzf ./influxdb2-client-2.7.5-linux-amd64.tar.gz

COPY ./dumps/influx/ ./

CMD sleep 5 && \
    ./influx write -b ${DOCKER_INFLUXDB_INIT_BUCKET} -f ./P.csv --host http://influxdb2:8086 --org ${DOCKER_INFLUXDB_INIT_ORG} --token ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN} && \
    ./influx write -b ${DOCKER_INFLUXDB_INIT_BUCKET} -f ./Irms.csv --host http://influxdb2:8086 --org ${DOCKER_INFLUXDB_INIT_ORG} --token ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN} && \
    ./influx write -b ${DOCKER_INFLUXDB_INIT_BUCKET} -f ./totalP.csv --host http://influxdb2:8086 --org ${DOCKER_INFLUXDB_INIT_ORG} --token ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN} && \
    ./influx write -b ${DOCKER_INFLUXDB_INIT_BUCKET} -f ./Urms.csv --host http://influxdb2:8086 --org ${DOCKER_INFLUXDB_INIT_ORG} --token ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN} && \
    ./influx write -b ${DOCKER_INFLUXDB_INIT_BUCKET} -f ./work.csv --host http://influxdb2:8086 --org ${DOCKER_INFLUXDB_INIT_ORG} --token ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}