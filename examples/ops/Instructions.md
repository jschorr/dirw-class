# Operations

We'll run through some examples of how to do some troubleshooting with Docker.

## Troubleshooting Builds

### Working Build

NOTE: enter the `working` directory to run this example.

First try building the nginx docker image locally and run it to make sure it's working:

```bash
> cd working && docker build -t nginx-working .
...
Successfully tagged nginx-working:latest
> docker run -p 8080:80 -d nginx-working
> curl localhost:8080
```

Stop the container before continuing: `> docker stop <containerId>`.

### Broken Build

NOTE: enter the `broken` directory to run these examples.

Sometimes it's very easy to see what went wrong during the build phase:

```bash
> docker build -t nginx-broken1 -f Dockerfile1 .
...
ERROR: unsatisfiable constraints:
  bogus (missing):
    required by: world[bogus]
The command '/bin/sh -c apk add --no-cache bogus' returned a non-zero code: 1
```

But sometimes it's not:

```bash
> docker build -t nginx-broken2 -f Dockerfile2 .
...
/bin/sh: /app/setup-nginx.sh: Permission denied
The command '/bin/sh -c /app/setup-nginx.sh' returned a non-zero code: 126
```

What went wrong? We seem to be hitting a permission issue.  Let's jump into a container to see what's going
on. Since the build failed, we can't reference the image by name as the name is assigned at the end of the
build phase. Let's look for our recent images so that we can get the failed image's `IMAGE ID`:

```bash
> docker images|head
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
<none>                                      <none>              ea0ef48170c0        4 minutes ago       21.2MB
```

Now we can fire up a container and connect to it:

```bash
> docker run -it --entrypoint ash ea0ef48170c0
/app # ls
setup-nginx.sh
/app # ./setup-nginx.sh
ash: ./setup-nginx.sh: Permission denied
# This script is missing execute permissions!
/app # ls -la
total 12
drwxr-xr-x    1 root     root          4096 Aug 20 17:09 .
drwxr-xr-x    1 root     root          4096 Aug 20 17:15 ..
-rw-r--r--    1 root     root           137 Aug 20 17:06 setup-nginx.sh
```

Let's fix our `RUN` line to add the executable bit: `chmod +x setup-nginx.sh` and try again:

```bash
> docker build -t nginx-broken2 -f Dockerfile2 .
...
> Successfully tagged nginx-broken2:latest
> docker run -p 8080:80 -d nginx-broken2
```

See how it crashes right away?  Run `docker ps -a` to see what happened. What stage actually broke?

Try looking at the logs.  In this case, it's so broken, the logs don't help much:

```bash
❯ docker logs <containerId>
nginx: applet not found
```

Since we see that it got all the way to `CMD`, let's fire it up, overriding the entrypoint so we can troubleshoot:

```bash
> docker run -it --entrypoint ash nginx-broken2
/app # nginx -v
nginx: applet not found
```

The nginx binary seems to be broken. Try running:

```bash
> which nginx
/usr/sbin/nginx
> ls -la /usr/sbin/nginx
```

There's our culprit. Note how convenient it is to be able to fire up a broken image so that you can
troubleshoot. Sometimes it's less time-consuming to just enter a container based off a broken build so
that you can try things in that _context_.

### Questions

* Note how the `setup-nginx.sh` script caused a problem that wasn't immediately obvious.  What could we
have done differently here?
* What are some guidelines that we can use to decide whether something belongs in an imported script or
explicitly declared in a Dockerfile?
* If our build broke, what's an easy way to jump into a container to troubleshoot?

## Troubleshooting run-time issues

Typically run-time issues fall into a couple of categories:

* incorrect or missing values (environmental)
* network configuration
* permissions
* storage configuration / mappings

It's usually best to follow this approach _before_ heading down the orchestration path:

* Does your Docker image work on it's own (builds *and* runs properly)?
* Are any environmental dependencies for runtime explicitly mentioned with examples in a `README.md` file?

Try starting up the Wordpress stack:

Note: if you're on a non-Linux box, ensure that Docker can access `/tmp`.

```bash
> mkdir -p /tmp/wp-demo/{html,database}
> docker-compose -f wordpress.yml up -d
```

Try setting up Wordpress by navigating to [http://localhost](http://localhost). Something seems to be wrong. We can look at the overall health and logs
for more info:

```bash
> docker-compose -f wordpress.yml ps
> docker-compose -f wordpress.yml logs -f
```

We can use a different Docker container to troubleshoot the authentication with _as long as_ we connect to
the same network. Paste in the value of `MYSQL_ROOT_PASSWORD` from the `wordpress.yml` file when prompted:

```bash
> docker run --name authtest3 -it --network broken_default mariadb bash -c "mysql -h broken_mariadb_1 -P 3306 -D wordpress -u root -p"
```

So we can see that that MariaDB is fine. Now we've isolated the issue to being the connection between
Wordpress and MariaDB.  Take a look at the Wordpress environmental variables.

### Class Project

Let's break up into two teams and do each of the following:

* Write a Dockerfile that:
  * Copies over static HTML files to serve from `/var/www/html` via Nginx.
  * Has a RUN command that has at least 3 commands daisy-chained together.
  * Exposes a port
  * Accepts some arguments
  * Imports and runs a script

* Have one person on your team purposely break the image.
* Try building it together and troubleshooting it.
