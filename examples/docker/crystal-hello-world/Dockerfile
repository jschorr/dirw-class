FROM jrei/crystal-alpine AS build

WORKDIR /app

RUN echo 'puts "Hello World!"' > hello-world.cr && \
  echo '# Hack to prevent a segfault for static linking \
    {% if flag?(:static) %} \
      require "llvm/lib_llvm" \
      require "llvm/enums" \
    {% end %}' >> hello-world.cr && \
  crystal build --static --release hello-world.cr



FROM scratch

COPY --from=build /app/hello-world ./

CMD ["/hello-world"]
