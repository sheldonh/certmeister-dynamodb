# certmeister-dynamodb

certmeister-dynamodb is an [AWS DynamoDB](http://aws.amazon.com/dynamodb/) store for [Certmeister](https://github.com/sheldonh/certmeister),
the conditionally autosigning Certificate Authority.

I haven't decided whether it's a good idea to allow for automatic provisioning from within the store.
By default, provisioning is not performed, and connecting to a non-existent DynamoDB table will produce an error.
For automated provisioning, provide the optional third argument (called provision) to the store constructor:

```
store = Certmeister::DynamoDB::Store.new(
  "CertmeisterCertificates",
  {region: 'us-east-1'},
  {read_capacity_units: 10, write_capacity_units: 5}
)
```

# Testing

The tests expect to be run against a [DynamoDB Local](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html) instance on port 8000 on the local host.
The instance can be started as follows:

```
java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -inMemory -sharedDb
```
