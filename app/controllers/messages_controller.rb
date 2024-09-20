class MessagesController < ApplicationController
  before_action :load_app, :load_chat

  def index
    messages = []
    Message.where(chat_id: @chat.id).find_each do |msg|
      messages << msg.attributes.except("id", "chat_id")
    end
    render json: messages, status: 200
  end

  def show
    msg = Message.find_by!(chat_id: @chat.id, number: params[:message_number])

    render json: msg.attributes.except("id", "chat_id")
  end

  def create
    message_count = @chat.messages_count || 0

    msg = Message.new(chat_id: @chat.id, body: message_params[:body], number: message_count+1)
    msg.save!

    @chat.update!(messages_count: message_count+1)

    render json: msg.attributes.except("id", "chat_number")
  end

  def update
    msg = Message.find_by!(chat_id: @chat.id, number: params[:message_number])
    msg.update!(body: message_params[:body])

    render json: { message: "Updated Successfully" }, status: 200
  end

  private

    def message_params
      params.require(:message).permit(:body)
    end

    def load_app
      @app = App.find_by!(token: params[:application_token])
    end

    def load_chat
      @chat = Chat.find_by!(application_token: params[:application_token], number: params[:chat_number])

      if @chat.nil?
        render json: { error: "Chat not found" }, status: :not_found
      end
    end
end
