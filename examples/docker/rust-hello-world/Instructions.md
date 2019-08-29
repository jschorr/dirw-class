# Instructions

## Build the image

```bash
> docker build -t rust-hello-world .
...
Sending build context to Docker daemon  5.632kB
Step 1/5 : FROM frolvlad/alpine-rust
 ---> e748d81ef32c
Step 2/5 : WORKDIR /app
 ---> Using cache
 ---> 764b6abb371a
Step 3/5 : COPY src/main.rs .
 ---> Using cache
 ---> 7da5ed8181f2
Step 4/5 : RUN rustc -O -o hello-world ./main.rs
 ---> Using cache
 ---> 6855fc866492
Step 5/5 : CMD ["/app/hello-world"]
 ---> Using cache
 ---> a330dd1d8627
Successfully built a330dd1d8627
Successfully tagged rust-hello-world:latest
```

Now run it:

```bash
> docker run rust-hello-world
Hello, world!
```

Note the size.

## Excercise

Update the Dockerfile to make it multi-stage the runtime image based upon alpine.  See `examples/docker/size-hello_world/Dockerfile-efficient` for what a multi-stage build looks like.  Build it again: `> docker build -t rust-hello-world-efficient .` and try running it.

* Try building the new image.  How much smaller was this image?
* Try overriding the entrypoint upon runtime with a shell.  What do you notice?
