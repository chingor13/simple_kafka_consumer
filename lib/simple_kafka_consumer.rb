require "simple_kafka_consumer/version"
require 'poseidon'
require 'poseidon_cluster'
require 'active_support/core_ext/class/attribute'

module SimpleKafkaConsumer
  autoload :Consumer, "simple_kafka_consumer/consumer"
end
