# Instructions

## Build the image

```bash
> docker build -t crystal-hello-world .
Sending build context to Docker daemon  4.096kB
Step 1/6 : FROM jrei/crystal-alpine AS build
 ---> 29ff57cd385e
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 064b3f803020
Step 3/6 : RUN echo 'puts "Hello World!"' > hello-world.cr &&   echo '# Hack to prevent a segfault for static linking     {% if flag?(:static) %}       require "llvm/lib_llvm"       require "llvm/enums"     {% end %}' >> hello-world.cr &&   crystal build --static --release hello-world.cr
 ---> Using cache
 ---> 46da09670928
Step 4/6 : FROM scratch
 --->
Step 5/6 : COPY --from=build /app/hello-world ./
 ---> Using cache
 ---> c13d111e3759
Step 6/6 : CMD ["/hello-world"]
 ---> Using cache
 ---> d8e1e80c6dab
Successfully built d8e1e80c6dab
Successfully tagged crystal-hello-world:latest
```

Now run it:

```bash
> docker run crystal-hello-world
Hello, world!
```

Note the size, it should be almost 4 times smaller than the Rust-based image due to using `scratch` as
our parent image. The lesson here is that whenever you have a single binary that can be statically compiled, you
can use a multi-stage build with `scratch` as your runtime image's parent image (via the `FROM` directive).
