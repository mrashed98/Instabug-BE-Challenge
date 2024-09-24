module ChatService
  def self.getChat(application_token, chat_number)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/#{chat_number}"
    response = JSON.parse(HTTParty.get(url).body)
    response.to_json
  end

  def self.getChats(application_token)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/"
    response = JSON.parse(HTTParty.get(url).body)
    response.to_json
  end

  def self.createChat(application_token)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/new"
    response = JSON.parse(HTTParty.post(url).body)
    response.to_json
  end
end
