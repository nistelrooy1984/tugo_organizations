#!/bin/sh

if [ $# -lt 1 ]; then
  cat <<_EOT_
Please specify the service name
ex.
docker-compose run --rm app sh scripts/proto_converter.sh crm
make update-pb SERVICE=campaigns
_EOT_
  exit 1
else
  rm -rf app/rpc_stubs/tugo/$1
  mkdir app/rpc_stubs/tugo/$1
  find tugo_grpc/proto/tugo/$1 -name "*.proto" | xargs grpc_tools_ruby_protoc -I ./tugo_grpc/proto --ruby_out=./app/rpc_stubs --grpc_out=./app/rpc_stubs
fi
