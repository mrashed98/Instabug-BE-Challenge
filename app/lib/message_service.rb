module MessageService
  def self.getMessages(application_token, chat_number)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/#{chat_number}/messages"
    response = JSON.parse(HTTParty.get(url).body)
    response.to_json
  end

  def self.getMessage(application_token, chat_number, msg_number)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/#{chat_number}/messages/#{msg_number}"
    response = JSON.parse(HTTParty.get(url).body)
    response.to_json
  end

  def self.createMessage(application_token, chat_number, body)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/#{chat_number}/messages/new"
    response = JSON.parse(HTTParty.post(url, body: { body: body }.to_json,
    headers: { "Content-Type" => "application/json" }).body)
    response.to_json
  end

  def self.updateMessage(application_token, chat_number, msg_number, body)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/#{chat_number}/messages/#{msg_number}/update"
    response = JSON.parse(HTTParty.put(url, body: { body: body }.to_json,
    headers: { "Content-Type" => "application/json" }).body)
    response.to_json
  end

  def self.searchMessage(application_token, chat_number, query)
    base_url = ENV["GO_SERVICE"] ||  "http://localhost:8080"
    url = "#{base_url}/applications/#{application_token}/chats/#{chat_number}/messages/search"
    response = JSON.parse(HTTParty.post(url, body: { query: query }.to_json,
    headers: { "Content-Type" => "application/json" }).body)
    response.to_json
  end
end
