FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
ENV TZ=Aisa/Ho_Chi_Minh LANG=C.UTF-8

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.0 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.7.0/migrate.linux-amd64.tar.gz | tar xvz
RUN cp migrate.linux-amd64 /usr/local/bin/migrate

WORKDIR /usr/src/app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . /usr/src/app
