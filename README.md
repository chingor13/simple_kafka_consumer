# SimpleKafkaConsumer

Write Kafka consumers in a model with retry

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_kafka_consumer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_kafka_consumer

## Usage

You will want to write your own consumer class that inherits from `SimpleKafkaConsumer::Consumer`. You will want to specify the `group_name` and `topic_name`. You'll also want to define the `consume` method which is the handler for batch of messages received.

```ruby
class MyConsumer < SimpleKafkaConsumer::Consumer
  # the name used for coordinating multiple consumers
  self.group_name = "my-group-name"

  # the kafka topic we're reading from
  self.topic_name = "my-topic-name"

  # handle the messages
  def consume(message)
    puts message
  end
end
```

### Formatting

You can have the consumer handle deserializing your data that is sent in the message. For example, if you used json as your message format:

```ruby
class MyConsumer
  def parse(message)
    JSON.parse(message)
  end

  # the message you're consuming is now a parsed json object
  def consume(json_object)
    puts json_object['name']
  end
end
```

### Creating and Running

To create a consumer instance, you'll need to provide an array of kafka servers and an array of zookeeper servers. You can optionally provide a logger as well.

```ruby
# create a consumer
kafka_servers = ["localhost:9092"]
zookeeper_servers = ["localhost:2181"]
consumer = MyConsumer.new(kafka_servers, zookeeper_servers, logger: nil)

# run the consumer (loops and blocks)
consumer.run
```

This gem utilizes the `poseidon_cluster` gem and consumers coordinate via zookeeper. Thus, you can run many consumers. The `group_name` is what's used to determine which messages have already been processed.

## Contributing

1. Fork it ( https://github.com/chingor13/simple_kafka_consumer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
