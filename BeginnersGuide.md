# Beginner's Guide

The purpose of this document is to help newcomers get familiar with the cosmos codebase. We want to make it
easy for new members to start contributing.

## Important Files and Folders

* cosmos-server/src/main/scala/com/mesosphere/cosmos//Cosmos.scala
	+ entry point for the server
* 

## Understanding The Codebase

Cosmos is an HTTP server. We can think of the server as a big switch-board. At the entry point
we can see all of the endpoints available to the client. For example the _package list versions_
endpoint looks like this:

```scala
val packageListVersions: Endpoint[Json] = {
  route(post("package" / "list-versions"), packageListVersionsHandler)(RequestReaders.standard)
}
```

All of the endpoints of the server respond to POST requests. However the server does not have REST Api. Rather it is
RPC over HTTP. This means that calling the endpoints is a little complicated as you must indicate both type of your
input, as well as the expected return type. See [Httpie Usage](#usage).

One important thing to note on the code snippet above is the ```packageListVersionsHandler```. This object is the place where
the request gets handled. So if you want to learn specifics about an endpont, this is the location to start.

### Tests


### Handlers
Handlers are fairly self contained code that in general easy to understand. They are objects with an apply method that
convers a request to a response. In this handlers that's all that needs to occur. One need not wory about the piping
or the versioning or the conversions. You just get a request of a type, and you produce the response of the specific
type.

### One Level Up

## Environment and Tools

### Zookeeper
Set up [zookeeper](https://blog.kompany.org/2013/02/23/setting-up-apache-zookeeper-on-os-x-in-five-minutes-or-less)

### Install Cosmos
See [Cosmos](https://github.com/dcos/cosmos)

```shell
mkdir /tmp/cosmos
java -jar cosmos-server/target/scala-2.11/cosmos-server_2.11-<version>-SNAPSHOT-one-jar.jar \
     -com.mesosphere.cosmos.dcosUri=<dcos-host-url>
```

### Httpie
[Httpie](https://github.com/jkbrzt/httpie) is a user friendly curl. This tool will help you sanity check the cosmos endpoints, 
if you ever need to see what they are doing. It's also a good exercise to figure out how cosmos works from an external perspective.

#### Installation
```shell
# on mac
brew install httpie
```

#### Usage
```shell
# Get the authorization Token
dcos auth login

# You can now poke the endpoints
http POST http://localhost:7070/package/${1} \
	Accept:"application/vnd.dcos.package.${1}-response+json;charset=utf-8;version=v1" \
	Content-Type:"application/vnd.dcos.package.${1}-request+json;charset=utf-8;version=v1" \
	Authorization:"token=$(dcos config show core.dcos_acs_token)" \
	${@:2}
	
```

## Running Tests

```bash
export COSMOS_AUTHORIZATION_HEADER="token=$(http --ignore-stdin http://${1}/acs/api/v1/auth/login uid=bootstrapuserassword=deleteme | jq -r ".token")"
sbt -Dcom.mesosphere.cosmos.dcosUri=http://${1}
```

