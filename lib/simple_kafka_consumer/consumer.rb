module SimpleKafkaConsumer
  class Consumer    
    class_attribute :group_name, :topic_name
    attr_reader :consumer, :logger
    def initialize(kafka_servers, zookeeper_servers, options = {})
      @logger = options.delete(:logger)
      @consumer = Poseidon::ConsumerGroup.new(
        group_name, 
        kafka_servers, 
        zookeeper_servers, 
        topic_name,
        options
      )
    end

    def run
      debug "partitions: #{consumer.partitions}"
      debug "claimed: #{consumer.claimed}"
      consumer.fetch_loop do |partition, bulk|
        bulk.each do |message|
          consume(parse(message))
        end
      end
    rescue ZK::Exceptions::OperationTimeOut => e
      log e.message
      retry
    end

    protected

    def parse(message)
      message
    end

    def log(message)
      return false unless logger
      logger.tagged(self.class) { logger.error message }
    end

    def debug(message)
      return false unless logger
      logger.tagged(self.class) { logger.debug message }
    end

    def consume(message)
      puts "doing nothing"
    end
  end
end