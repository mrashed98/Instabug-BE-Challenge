class MessagesController < ApplicationController
  before_action :load_app, :load_chat
  wrap_parameters false

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
    message_count = $redis.incr(params[:application_token] + "-chat_number-" + params[:chat_number] + "-message_number")

    MessageWorkerJob.perform_async(message_params[:body], @chat.id, message_count)

    render json: { message_number: message_count }, status: 201
  end

  def update
    msg = Message.find_by!(chat_id: @chat.id, number: params[:message_number])
    msg.update!(body: message_params[:body])

    render json: { message: "Updated Successfully" }, status: 200
  end

  def search
    if params[:query].present?
      messages = Message.search(@chat.id, params[:query])
      render json: messages, status: 200
    else
      render json: { message: "Query Paramter Missing" }, status: 400
    end
  end


  private

    def message_params
      params.permit(:body, :application_token, :chat_number)
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
