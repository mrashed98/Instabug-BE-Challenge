class MessageWorkerJob
  include Sidekiq::Job

  sidekiq_options queue: "messages"

  def perform(msg_body, id, msg_number)
    Message.create!(body: msg_body, chat_id: id, number: msg_number)
  rescue => e
    logger.error "Failed to create message: #{e.message}"
  end
end
