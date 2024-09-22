require 'rails_helper'

RSpec.describe "Messages API" do
  let!(:ap) { create(:app) }
  let!(:chats) { create_list(:chat, 20, application_token: ap.token) }
  let!(:msgs) { create_list(:message, 10, chat_id: chats.first.id, body: "Instabug BE Challenge") }
  let!(:dummy_msgs) { create_list(:message, 10, chat_id: chats.first.id, body: "Challenge") }

  let(:application_token) { ap.token }
  let(:chat_number) { chats.first.number }
  let(:msg_number) { msgs.first.number }

  describe "GET /applications/:application_token/chats/:chat_number/messages" do
    before { get "/applications/#{application_token}/chats/#{chat_number}/messages" }

    context 'when chat exist' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return all messages in the chat' do
        expect(JSON.parse(response.body).size).to eq(20)
      end
    end

    context 'when chat not exist' do
      let(:chat_number) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found msg' do
        expect(response.body).to match(/Record Not found/)
      end
    end
  end

  describe "GET /applications/:application_token/chats/:chat_number/messages/:message_number" do
    before { get "/applications/#{application_token}/chats/#{chat_number}/messages/#{msg_number}" }

    context "when msg exist" do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns msg correctly' do
        expect(JSON.parse(response.body)["body"]).to match(/Instabug BE Challenge/)
      end
    end

    context "when msg not exist" do
      let(:msg_number) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns record not found msg' do
        expect(response.body).to match(/Record Not found/)
      end
    end
  end

  describe "POST /applications/:application_token/chats/:chat_number/messages/new" do
    context "When requests attributes are valnumber" do
      before { post "/applications/#{application_token}/chats/#{chat_number}/messages/new", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Body can't be missing or blank/)
      end
    end

    context "When request attributes are valid" do
      let(:valid_attributes) { { body: "Hello From Rspec" } }

      before { post "/applications/#{application_token}/chats/#{chat_number}/messages/new", params: valid_attributes }

      it "Create the msg" do
        expect(JSON.parse(response.body)["message_number"]).to eq(1)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end
end
