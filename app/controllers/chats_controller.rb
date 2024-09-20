class ChatsController < ApplicationController
  before_action :load_app


  def index
    chats = []
    Chat.where(application_token: params[:application_token]).find_each do |chat|
      chats << chat.attributes.except("id", "application_token")
    end
    render json: chats, status: 200
  end

  def show
    chat = Chat.find_by!(application_token: params[:application_token], number: params[:chat_number])

    render json: chat.attributes.except("id", "application_token"), status: :ok
  end

  def create
    chat_count = $redis.incr(params[:application_token] + "-chat_number")

    ChatWorkerJob.perform_async(@app.token, chat_count)

    render json: { chat_number: chat_count }, status: 201
  end

  private
    def load_app
      @app = App.find_by!(token: params[:application_token])
    end
end
