require 'sneakers'
require 'sneakers/runner'
require 'logger'

class Uploader

  def initialize(queue:, bucket:, rabbitmq_host:, rabbitmq_port:, rabbitmq_user:, rabbitmq_password:)
    ENV['LISTEN_QUEUE'] = queue
    ENV['UPLOAD_BUCKET'] = bucket

    Sneakers.configure(
      amqp: "amqp://#{rabbitmq_user}:#{rabbitmq_password}@#{rabbitmq_host}:#{rabbitmq_port}",
      daemonize: false,
      log: STDOUT,
      workers: 1,
      timeout_job_after: 60
    )

    Sneakers.logger.level = Logger::INFO

    puts "Uploader initilized. Listen queue: #{queue}. Upload bucket: #{bucket}"
  end

  def start()
    require_relative 'uploader/worker'
    r = Sneakers::Runner.new([ UploaderWorker ])
    r.run
  end
end