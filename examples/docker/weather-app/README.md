# Weather App

## Pre-Requisite

Sign up at OpenWeatherMap.org and generate an API key.

## Clone the repo
We'll use a slightly modified version of the project found at [https://github.com/bmorelli25/simple-nodejs-weather-app/](https://github.com/bmorelli25/simple-nodejs-weather-app/).  
For security reasons, we'll be passing the API key in via an environment file.  Create a new file named 
`.env_vars` in the current `examples/docker/weather-app` directory with the following in it:

```bash
WEATHER_API_KEY=<OpenWeatherMapApiKey>
```

## Build the image

`> docker build -t weather-demo:1.0.0 .`

## Run the image:

```bash
> docker run -p 3000:3000 weather-demo:1.0.0
Example app listening on port 3000!
```

Open [http://localhost:3000](http://localhost:3000) with a web browser and search for a city.
You should receive an error because our OpenWeatherMap API key environmental variable 
isn't being found.  Stop the container via `docker stop weather-demo:1.0.0` and then run 
it again, being sure to let the docker engine know the location of your environment file:

```bash
> docker run -p 3000:3000 --env-file .env_vars weather-demo:latest
Example app listening on port 3000!
```

Now try it out, it should work.

## Exercises

* Try adding more packages to the `apk` line of the original `Dockerfile` and build the 
image again.  What do you notice about the build process?

* Purposely break the image by editing the `Dockerfile` by changing `apk` to `apt`.  Try building 
it again. Enter the container and see if you can troubleshoot the issue (hint `docker run -it --rm <imageId> ash`).

* Enter the container and run `env`.  You should see that the Docker engine injected the
  `WEATHER_API_KEY` environmental variable into the environment.  Since you injected the 
  API key at runtime, the value of the key won't be exposed in the image history:

  ```bash
  # You *shouldn't* see the API key exposed...
  > docker history weather-demo:1.0.0 --no-trunc|grep WEATHER
  ```

  Try updating the `sed` line to replace the `process\.env\.WEATHER_API_KEY` text with
  `123456abcdefg` and rebuild the image; you *should* now see the API key exposed now, which 
  is terrible:

  ```bash
  > docker build -t weather-demo:1.0.0-insecure .
  > docker history weather-demo:1.0.0 --no-trunc|grep WEATHER
  ```

  It's critical that we do not store any secrets inside of an image but rather reference them at 
  runtime.  This approach also allows us to have different credentials per environment.

* Enter the running container and try to add `ncdu` so we can easily look into why the image is 
  still so big (you should hit quite a stumbling block trying to do this):

  ```bash
  > apk add ncdu
  ```

    * What went wrong?
    * How can we get around this (hint look at Docker history)?  There are at least two ways to 
      get around this.
