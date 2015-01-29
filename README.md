# certmeister-dynamodb

certmeister-dynamodb is an [AWS DynamoDB](http://aws.amazon.com/dynamodb/) store for [Certmeister](https://github.com/sheldonh/certmeister),
the conditionally autosigning Certificate Authority.

# Testing

The tests expect to be run against a [DynamoDB Local](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html) instance on port 8000 on the local host.
The instance can be started as follows:

```
java -Djava.library.path=. -jar DynamoDBLocal.jar -inMemory
```
