require 'rails_helper'

RSpec.describe 'Chats API' do
    let!(:ap) { create(:app) }
    let!(:chats) { create_list(:chat, 20, application_token: ap.token) }

    let(:application_token) { ap.token }
    let(:chat_number) { chats.first.number }


    describe 'GET /applications/:application_token/chats' do
        before { get "/applications/#{application_token}/chats" }

        context 'when app exists' do
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns all app chats' do
                expect(JSON.parse(response.body).size).to eq(20)
            end
        end

        context 'when app does not exist' do
            let(:application_token) { 0 }

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end

            it 'returns a not found msg' do
              expect(response.body).to match(/Record Not found/)
            end
        end
    end

    describe 'GET /applications/:application_token/chats/:chat_number' do
        before { get "/applications/#{application_token}/chats/#{chat_number}" }

        context 'when app chat exists' do
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns the chat' do
                expect(JSON.parse(response.body)['messages_count']).to eq(0)
                expect(JSON.parse(response.body)['number']).to eq(chat_number)
            end
        end

        context 'when app chat does not exist' do
            let(:chat_number) { 0 }

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end

            it 'returns a not found message' do
                expect(response.body).to match(/Record Not found/)
            end
        end
    end

    describe 'POST /applications/:application_token/chats/new' do
        context 'when request attributes are valnumber' do
            before { post "/applications/#{application_token}/chats/new", params: {} }

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
        end
    end
end
