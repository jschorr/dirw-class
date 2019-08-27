FROM frolvlad/alpine-rust

WORKDIR /app

COPY src/main.rs .

RUN rustc -O -o hello-world ./main.rs

USER nobody

CMD ["/app/hello-world"]
