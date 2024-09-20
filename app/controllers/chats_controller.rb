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
    chat_count = @app.chats_count || 0

    # Create a new chat and assign the application_token manually
    chat = Chat.new(application_token: @app.token, number: chat_count + 1, messages_count: 0)
    chat.save!

    # Update the app's total chats count
    @app.update!(chats_count: chat_count + 1)

    render json: decorator(chat), status: 201
  end

  private
    def load_app
      @app = App.find_by!(token: params[:application_token])
    end
end
