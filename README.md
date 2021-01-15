
# Go Redis Kafka Demo

A demo application that interacts with Kafka (producer & consumer) + Redis

This application has 2 parts
1. **http-server**
2. **kafka-consumer**

The http-server handles 2 routes

1. http://127.0.0.1:8080/produce - this produces an event on kafka of the shape `{ type: "number", number: 123333 }` the kafka-consumer listens to this event and determines whether the number is odd/even and based on that increments (`incr`) a key in redis
2. http://127.0.0.1:8080/ - gives you statistics like `{"requests":12,"even":5,"odd":7}` number of events/requests processed so far, number of odd numbers, number of even numbers

  
# To run this project
 
1. [Install go](https://www.tecmint.com/install-go-in-linux/) & [setup your development environment](https://golang.org/doc/code.html)
2. Install Redis
3. Install Kafka & make a topic call `numbers` (you can name the topic something else also; but make sure the name of the topic is correct in `start.sh`)
4. RUN `./start.sh`

the `start.sh` contains enviroment variables you need to handle it according to you convinence


*****************************************************************************************

Work Done so far by Kaviya Kulothungan

1. I have dockerized all the dependencies in docker-compose-dependencies.yml file:

- selected the docker containers for kafka, redis and zookeeper (zookeeper is a dependecy for kafka).
- exposed the required ports for the kafka, redis and zookeeper for this application to run
- wrote a command to mount all the logs (data and datalog) of the application in the local. 

for kafka: 
/zk-single-kafka-single/zoo1/data
/zk-single-kafka-single/zoo1/data/datalog

Redis: 
./zk-single-kafka-single/kafka1/data

zookeeper:
./zk-single-kafka-single/zoo1/data
./zk-single-kafka-single/zoo1/datalog

2. Run a seperate command to create a topic in Kafka:

Command: 
docker exec -it single-kafka /opt/kafka/bin/kafka-topics.sh --zookeeper single-kafka:2181 --create --topic number --partitions 1 --replication-factor 1

3. Created a "docker-compose-app.yml" for run the application, I have also added a command to create an image there. I have taken all the environment properties from shell.sh and added in this file.

Reason:

when we define property in the shell script, those will be temporary variables available only during the execution. After execution, theose properties will not be available. In order for them to be available throughout (before and after execution) i have defined them in the docker-compose-app.yml file as environment variables.

4. I have also created a dockerfile where I have added a run command from start.sh file as below:

RUN export GO111MODULE=on && \
    go mod download && \
    go install ./...

CMD ["http-server"]


When we call the docker-compose-app.yml file, this dockerfile will be called and executed. 

5. The application is run in the docker console using the following commands:

-> docker-compose -f docker-compose-dependencies.yml up --build    (to build the docker dependencies)
-> docker-compose -f docker-compose-dependencies.yml up            (to run the docker compose)
-> docker exec -it single-kafka /opt/kafka/bin/kafka-topics.sh --zookeeper single-kafka:2181 --create --topic number --partitions 1 --replication-factor 1            (to create kafka topic)
-> docker-compose -f docker-compose-app.yml up --build             (to build the go application)
-> docker-compose -f dokcer-compose-app.yml up                     (to run the go application in docker)

6. I have uploaded the created docker image in to docker hub under the following location:

https://hub.docker.com/repository/docker/kaviyakulothungan/goapp
Tag name: v1

Command used: docker push

