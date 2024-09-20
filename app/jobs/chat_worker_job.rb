class ChatWorkerJob
  include Sidekiq::Job

  sidekiq_options queue: "chats"

  def perform(app_token, chat_number)
    Chat.create!(application_token: app_token, number: chat_number, messages_count: 0)
  rescue => e
    logger.error "Failed to create chat: #{e.message}"
  end
end
