FROM alpine

ARG pkgname="simple-nodejs-weather-app"
ARG reponame="https://github.com/bmorelli25"

# Prerequisites...
RUN apk --no-cache --update add git nodejs npm

WORKDIR /app

# Clone the repo
# Note: typically you would not do this unless you knew it was a legitimate artifact; for the 
# sake of this class, we're doing it inside the container so that students don't need to have 
# git configured. Ideally, your code would have a CI/CD pipeline that instead copied the code 
# in via a `COPY` directive or downloaded an artifact from an approved repository.
RUN git clone "$reponame/$pkgname"

# Our app will end up running from this directory.
WORKDIR "/app/$pkgname"

# Reference the API key and install the dependencies, and ensure the 'nobody' user has access...
RUN sed -i "s/^const apiKey.*/const apiKey = process\.env\.WEATHER_API_KEY;/g" server.js && \
    npm install --production --quiet --save && \
    chown -R nobody /app

# Run as a limited user
USER nobody

CMD ["node", "server"]

