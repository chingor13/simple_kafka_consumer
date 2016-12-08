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
          process(parse(message))
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
      logger.info message
    end

    def debug(message)
      return false unless logger
      logger.debug message
    end

    def consume(message)
      puts "doing nothing"
    end

    def process(message)
      meter(message) do
        consume(message)
      end
    end

    def meter(message) do
      yield
    end
  end
end