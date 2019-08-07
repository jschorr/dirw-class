# Image building

## Simple image

Building the image: `docker build -f Dockerfile-1 -t image1 .`.  Run it now:

```bash
❯ docker run image1
total 124
drwxr-xr-x 1 root root   4096 Jul  8 17:26 .
drwxr-xr-x 1 root root   4096 Jul  8 16:56 ..
-rw-r--r-- 1 root root     11 Jul  8 17:26 helloworld.txt
```

## The ENTRYPOINT directive

You can override the default CMD or ENTRYPOINT at runtime:

`docker run --entrypoint "ls" image1 -la /app/tools`.


## The ADD directive

Building the image: `docker build -f Dockerfile-2 -t image2 .`.  Run it now:

Run it now:

```bash
❯ docker run image2
total 124
drwxr-xr-x 1 root root   4096 Jul  8 17:26 .
drwxr-xr-x 1 root root   4096 Jul  8 16:56 ..
-rw------- 1 root root 112385 Jan  1  1970 v0.8.3.tar.gz
```

Try modifying the `ADD` directive to end up with a more descriptive file name.

## The RUN directive

Look at the `Dockerfile-3` image.  There are several issues with this image.  For now,
please build the image and run it:

```bash
> docker build -f Dockerfile-3 -t image3 .
> docker run image3
version 0.8.3
```

It's nice that we can see the version but it's not very helpful.  What if we want to run the application?  Try the following:

```bash
> docker run --entrypoint nethogs image3
Error opening terminal: unknown.
```

Why is this?  Nethogs requires a TTY to run.  As a result, we need to run this container "interactively":

```bash
> docker run -it --entrypoint nethogs image3
```

Press `q` or `CTRL-D` to quit.

## Installing a different version of Nethogs

One day, we get a strange requirement: prepare an image with a newer version of Nethogs
but don't update the `Dockerfile`.  We can accomplish this by:

```bash
> docker build --build-arg NETHOGS_VERSION=0.8.5 -f Dockerfile-3 -t image3-nh-0.8.5 .
> docker run image3-nh-0.8.5
version 0.8.5
```

## Discussion: Optimizing the image

Run `docker images|grep image` and note how much larger `image3` is than the other images.

* Why is this?
* What can we do to improve this image?

```bash
> docker build -f Dockerfile-4 -t image4 .
> docker run image4
version 0.8.3
```

Run `docker images|grep image`. Note that `image4` is smaller. However, it's not much smaller. Let's
troubleshoot this issue:

```bash
docker run -it image4 bash
> apt-get update && apt-get install ncdu
> cd /
> ncdu
```

Questions:

* What directories should we consider removing?
* How would we go about it?
* Try it out and run it again - is the image smaller?

In future examples, we'll learn how to reduce this size even more through more advanced practices.
