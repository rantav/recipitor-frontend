# A message queue, currently implemented as amz sqs
# ==== Examples:
# To create a new message queue invoke <tt>MessageQueue.new("my_queue_name")</tt>
# To list all current queues invoke <tt>MessageQueue.list</tt>
class MessageQueue


  @@properties = YAML.load(ERB.new(File.read(Rails.root.join('config/sqs.yml'))).result)

  # Lists all the currently available message queues
  def self.list
    sqs = Aws::Sqs.new(@@properties['access_key_id'], @@properties['secret_access_key'], @@properties)
    mqs = []
    for i in sqs.queues do
      mqs.push(MessageQueue.new(i))
    end
    mqs
  end

  # Creates a new MessageQueue instance.
  # +q+:: queue name or queue instance. If it's an instance of String then a new queue is created with that name dynamically. Otherwise, it's assumed to be a valid queue and it's only wrapped by this constructor
  #
  # ==== Examples:
  # MessageQueue.new("my_queue_name")
  # MessageQueue.new(my_queue_instance)
  def initialize(q)
    @sqs = Aws::Sqs.new(@@properties['access_key_id'], @@properties['secret_access_key'], @@properties)
    if q.instance_of?(Aws::Sqs::Queue) 
      @aws_queue = q
    elsif q.instance_of?(MessageQueue) 
      @aws_queue = q.aws_queue
    elsif q.instance_of?(String)
      @aws_queue = @sqs.queue(q)
    else
      raise "Invalid queue type #{q}"
    end
  end

  def name
    @aws_queue.name
  end
  
  def url
    @aws_queue.url
  end

  # Estimated number of messages in the queue
  def size
    @aws_queue.size
  end

  def visibility
    @aws_queue.visibility
  end
  
  # Deletes the queue
  def delete
    @aws_queue.delete
  end

  def send(message)
    logger.info "Sending message #{message} to #{name}"
    @aws_queue.push message
  end

  protected
  def logger
    Rails.logger
  end
end
