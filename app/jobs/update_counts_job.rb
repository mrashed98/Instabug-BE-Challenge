class UpdateCountsJob
  include Sidekiq::Job

  sidekiq_options queue: "update_counts"


  def perform
    App.find_each do |app|
      chat_count = Chat.where(application_token: app.token).length
      app.update!(chats_count: chat_count)
    end

    Chat.find_each do |chat|
      message_count = Message.where(chat_id: chat.id).length
      chat.update!(messages_count: message_count)
    end
  end
end
