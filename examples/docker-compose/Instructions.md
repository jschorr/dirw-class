# Docker Compose

Docker Compose lets you setup a system which is composed of multiple containers, all *running on the same host*.

## Commands

Look through the available arguments and discuss them:

* docker-compose --help

Fyi, sometimes it's good to use `--force-recreate` if you've changed the yml or images.

## Examples

The following examples show simple configurations and *should not* be used in Production.

### Erlang Distributed Cluster

This example is based off a simple Erlang distributed cluster:

```bash
❯ docker-compose -f erlang.yml up -d
Starting host2.com ... done
Starting host1.com ... done
Starting host3.com ... done
> docker exec -it host2.com erl -name test@host2.com -setcookie cookie -remsh app@host2.com
(app@host2.com) 1> net_adm:ping('app@host3.com').
(app@host2.com) 2> pong
```

Discussion Questions:

* Take the cluster down and try scaling node 3. You should run into an issue.  Discuss the cause and resolution.
* Try pausing and resuming the cluster.
* Try pausing node 2.
* View the events in a different terminal window (e.g. `docker-compose -f erlang.yml events`).
* Unpause node 2.

### Wordpress and MariaDB

Note, if you're on a non-Linux box, ensure that Docker can access `/tmp`.

```bash
> mkdir -p /tmp/wp-demo/{html,database}
> docker-compose -f wordpress.yml up -d
```

Wait a minute or two as it'll take a little while for the database to be ready.

Discussion Questions:

* Change the `MYSQL_ROOT_PASSWORD` on line 16 of `wordpress.yml` and fire the cluster back up again.  What happens and why?
* Change the `MYSQL_ROOT_PASSWORD` on line 16 of `wordpress.yml` and fire the cluster back up again.  What happens and why?
* Why didn't you have to specify a port number for MariaDB in the YAML file?

### MongoDB Replica Set

```bash
> mkdir -p /tmp/mongo-demo && cp resources/mongodbsetup.sh /tmp/mongo-demo/
> docker-compose -f mongodb.yml up
```

After a minute or two, you should see that an election has taken place and there is now a primary and two
secondary replica set members. You should see `***READY***` from the `commander` output to STDOUT.  Connect
to the `commmander` container and view the replica set status:

```bash
> docker exec -it docker-compose_commander_1 mongo member<NUM>:27017
> show dbs
> rs.status()
> exit
```

Discussion Questions:

* Try the `mongo` command via the `commander` container again *without* the port number. What happens and why?
* Look at `docker network ls`.  There is one listed as `docker-compose_default` - why?
* Please look at the `mongodb.yml` Docker Compose file. Why is this setup is pretty dangerous? Note that since there
  are no mounted volumes for the data itself, we could lose data if a member node crashed and replication hadn't
  completed.  Remember, it's critical to *not* count on a container to store state. How would we rectify this?

### Real-life

Look through some of the real-life examples as a class and discuss them.

## Exercise

* Try writing a docker-compose file that has a MariaDB database, a Redis database, and one more component (API, Nginx, etc...).
