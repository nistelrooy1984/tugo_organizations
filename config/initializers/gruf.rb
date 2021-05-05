# frozen_string_literal: true

require 'gruf'

Dir.glob(Rails.root.join('app', 'rpc_stubs', '**', '*_services_pb.rb')).sort.each do |f| require f end

Gruf.configure do |c|
  c.server_options[:pool_size] = ENV.fetch('GRPC_MAX_THREADS', GRPC::RpcServer::DEFAULT_POOL_SIZE).to_i
  c.server_binding_url = '0.0.0.0:50051'
  c.backtrace_on_error = !Rails.env.production?
  c.backtrace_on_error = !Rails.env.production?
  c.use_exception_message = !Rails.env.production?
end
