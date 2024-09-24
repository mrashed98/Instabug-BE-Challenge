class ChatsController < ApplicationController
  before_action :load_app


  def index
    chats = ChatService.getChats(@app.token)
    if chats == nil
      render json: { error: "Error occurred while getting chats" }, status: 500
      return
    end

    render json: chats, status: 200
  end

  def show
    chat = ChatService.getChat(@app.token, params[:chat_number])

    if chat == nil
      render json: { error: "Error occurred while getting chat" }, status: 500
      return
    end

    render json: chat, status: :ok
  end

  def create
    chat_count = ChatService.createChat(@app.token)


    if chat_count == nil
      render json: { error: "Error occurred while creating chat" }, status: 500
      return
    end

    render json: chat_count, status: 201
  end

  private
    def load_app
      @app = App.find_by!(token: params[:application_token])
    end
end
