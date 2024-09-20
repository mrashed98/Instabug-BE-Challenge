class AppsController < ApplicationController
  def index
    apps = []
    App.all.find_each do |app|
      apps << app.attributes.except("id")
    end
    render json: apps, status: 200
  end

  def show
    app = App.find_by!(token: params[:application_token])
    render json: app.attributes.except("id"), status: 200
  end

  def create
    app = App.create!(name: app_params[:name], chats_count: 0)
    render json: { token: app.token }, status: 201
  end

  def update
    app = App.find(params[:application_token])
    app.update!(name: app_params[:name])
    render json: { message: "Updated Successfully" }, status: 200
  end

private
  def app_params
    params.permit(:name)
  end
end
