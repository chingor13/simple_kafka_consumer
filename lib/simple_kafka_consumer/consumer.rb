module SimpleKafkaConsumer
  class Consumer    
    class_attribute :group_name, :topic_name
    attr_reader :consumer, :logger
    def initialize(kafka_servers, zookeeper_servers, logger: nil)
      @consumer = Poseidon::ConsumerGroup.new(
        group_name, 
        kafka_servers, 
        zookeeper_servers, 
        topic_name
      )
      @logger = logger
    end

    def run
      debug "partitions: #{consumer.partitions}"
      debug "claimed: #{consumer.claimed}"
      consumer.fetch_loop(&method(:consume))
    rescue ZK::Exceptions::OperationTimeOut => e
      log e.message
      retry
    end

    protected

    def log(message)
      return false unless logger
      logger.info message
    end

    def debug(message)
      return false unless logger
      logger.debug message
    end

    def consume(partition, bulk)
      puts "doing nothing"
    end
  end
end