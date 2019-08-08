# Docker Swarm

Docker Swarm lets you setup a system which is composed of multiple containers, all *running on the different hosts*.
Typically, you'll use a `stack` YAML file to deploy the services; see
[https://docs.docker.com/engine/swarm/stack-deploy/](https://docs.docker.com/engine/swarm/stack-deploy/) for more
information.

## Commands

Look through the available arguments and discuss them:

* docker-swarm --help

Typically, you'll think in terms of services.  There are two types:

* replicated (you specify the amount)
* global (one task per node, *including* manager nodes)

See [https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#replicated-and-global-services](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#replicated-and-global-services) for more information.

## Example

### Setup

```bash
# on the 'manager' node
> docker swarm init --advertise-addr 10.128.255.97
Swarm initialized: current node (raskcgowd0jpk8lajfhmy05uh) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-ah28m2389hg18e8bccq6xcpaf5u66vf1x6veggdvgo35631wybz-hay27s80crq9zm4u3jebgu1jo 10.128.255.97:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
# on each 'worker' node
> docker swarm join --token SWMTKN-1-ah28m2389hg18e8bccq6xcpaf5u66vf1x6veggdvgo35631wybz-hay27s80crq9zm4u3jebgu1jo 10.128.255.97:2377
# on the manager node
> docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
raskcgowd0jpk8lajfhmy05uh *   swarm-manager       Ready               Active              Leader              18.09.7
7gyfbxxrb9kc4i1tb3lr5myxj     swarm-worker-01     Ready               Active                                  18.09.7
qwf57ry5fb7yme276hi54ak15     swarm-worker-02     Ready               Active                                  18.09.7
```

### Operations

* Tear down the cluster and set it up again.
* Remove a node from the cluster.
* Setup an Nginx service and try to `curl localhost:8080`:

  ```bash
  > docker service create --name nginx-svc --replicas 3 nginx
  ```

  You should see an error.  We forgot to map the port. Try again; now you
  should get a response for CuRL:

  ```bash
  > docker service create --name nginx-svc --replicas 3 -p 8080:80 nginx
  ```

* List the services in the cluster: `docker service ls`
* List the tasks for a service: `docker service ps nginx-svc`
* Inspect a service:

  ```bash
  > docker service inspect nginx-svc
  > docker service inspect --pretty nginx-svc
  ```

* Scale a service:

  ```bash
  > docker service update --replicas 11 nginx-svc
  # OR
  > docker service scale nginx-svc=11
  > docker service ls
  ```

* Delete a service: `docker service rm nginx-svc`
* Distribution:
  * label a node: `docker node update --label-add geo=us-west <NODE_NAME>`
  * create a service explicitly based on a labeled constraint:
    `docker service create --name nginx-us-west --constraint node.labels.geo=us-west --replicas 3 nginx-svc`
  * or distribute it automatically across nodes based upon a labeled constraint:
    `docker service create --name nginx-us-west --placement-pref spread=node.labels.ge --replicas 3 nginx-svc`
  * `docker node ls`
