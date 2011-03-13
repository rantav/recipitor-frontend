class MessageQueue

  attr_accessor :aws_queue

  @@properties = YAML.load(ERB.new(File.read(Rails.root.join('config/sqs.yml'))).result)

  def self.all
    [MessageQueue.new(@@properties['q_extract_store_name_request']), MessageQueue.new(@@properties['q_extract_store_name_response'])]
  end

  def initialize(name)
    @sqs = Aws::Sqs.new(@@properties['access_key_id'], @@properties['secret_access_key'], @@properties)
    @aws_queue = @sqs.queue(name)
  end

  def name
    @aws_queue.name
  end
  
  def url
    @aws_queue.url
  end

  def size
    @aws_queue.size
  end

#  def message_on_top
#    @aws_queue.receive
#  end
end
