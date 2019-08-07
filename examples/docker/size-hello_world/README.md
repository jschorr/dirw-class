# Size Example: Hello World

## Inefficient

```bash
> docker build -t inefficient -f Dockerfile-inefficient .
```

## Efficient

This approach uses a multi-stage build, resulting in a final image that is
substantially smaller than the above image.

```bash
> docker build -t efficient -f Dockerfile-efficient .
```

## Running the images

Note that running these images have the same result:

```bash
> docker run efficient
hello world
> docker run inefficient
hello world
```

## Size Comparisons

Note how much smaller the efficient image is:

```bash
> docker images|less
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
efficient                                   latest              0de9ded2c193        3 minutes ago       2MB
inefficient                                 latest              817b885b60b1        8 minutes ago       784MB
```

Wow, quite a difference!
