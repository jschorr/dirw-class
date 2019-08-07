# Real-life Examples

There are quite a few great examples of well-done `Dockerfile` examples that can be found. Please
see [https://github.com/docker-library](https://github.com/docker-library) for the official Docker images.

## Examples (local)

In this `examples` directory are some images which range from badly written to pretty good.  These can be used as
points of discussion around best practices.

## Examples (VCS)

### ENTRYPOINT with CMD

Remember that `ENTRYPOINT` allows the container to be run like a binary. When used in combination with `CMD`, it's quite
powerful. If commands are *not* passed in at runtime, the command(s) listed in `CMD` are run.

See [https://github.com/docker-library/mysql/blob/master/5.7/Dockerfile](https://github.com/docker-library/mysql/blob/master/5.7/Dockerfile)

### Multiple source OS's

See [https://github.com/nodejs/docker-node/tree/master/12](https://github.com/nodejs/docker-node/tree/master/124)
