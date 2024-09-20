Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/applications" => "apps#index"
  get "/applications/:application_token" => "apps#show"
  post "/applications/new" => "apps#create"
  put "/applications/:application_token/update" => "apps#update"

  get "/applications/:application_token/chats" => "chats#index"
  get "/applications/:application_token/chats/:chat_number" => "chats#show"
  post "/applications/:application_token/chats/new" => "chats#create"

  get "/applications/:application_token/chats/:chat_number/messages" => "messages#index"
  get "/applications/:application_token/chats/:chat_number/messages/:message_number" => "messages#show"
  post "/applications/:application_token/chats/:chat_number/messages/new" => "messages#create"
  put "/applications/:application_token/chats/:chat_number/messages/:message_number" => "messages#update"
end
