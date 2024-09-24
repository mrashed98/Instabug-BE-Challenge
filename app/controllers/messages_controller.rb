class MessagesController < ApplicationController
  before_action :load_app
  wrap_parameters false

  def index
    messages = MessageService.getMessages(@app.token, message_params[:chat_number])
    if messages == nil
      render json: { error: "Error occurred while geting the messages, please try again later" }, status: 500
      return
    end

    render json: messages, status: 200
  end

  def show
    msg = MessageService.getMessage(@app.token, message_params[:chat_number], message_params[:message_number])

    if msg == nil
      render json: { error: "Error occurred while geting the messages, please try again later" }, status: 500
      return
    end

    render json: msg, status: 200
  end

  def create
    validated_params = message_params
    if validated_params[:body].blank?
      return render json: { error: "Validation failed: Body can't be missing or blank" }, status: :unprocessable_entity
    end

    message_count = MessageService.createMessage(validated_params[:application_token], validated_params[:chat_number], validated_params[:body])
    if message_count == nil
      render json: { error: "Error occurred while creating the messages, please try again later" }, status: 500
      return
    end

    render json: message_count, status: 201
  end

  def update
    msg = MessageService.updateMessage(@app.token, message_params[:chat_number], message_params[:message_number], message_params[:body])

    if msg == nil
      render json: { error: "Error occurred while updatinh the message, please try again later" }, status: 500
    end

    render json: { message: "Updated Successfully" }, status: 200
  end

  def search
    if params[:query].present?
      messages = MessageService.searchMessage(message_params[:application_token], message_params[:chat_number], params[:query])

      if messages == nil
        render json: { error: "Error occurred while getting the messages, please try again later" }, status: 500
        return
      end

      render json: messages, status: 200
    else
      render json: { message: "Query Paramter Missing" }, status: 400
    end
  end

  private

    def message_params
      params.permit(:body, :application_token, :chat_number, :message_number)
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
