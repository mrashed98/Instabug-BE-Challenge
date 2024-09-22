require 'rails_helper'

RSpec.describe 'Apps API', type: :request do
    let!(:apps) { create_list(:app, 10) }
    let(:application_token) { apps.first.token }

    describe 'GET /applications' do
        before { get '/applications' }

        context 'get all apps' do
            it 'returns apps' do
                expect(JSON.parse(response.body)).not_to be_empty
                expect(JSON.parse(response.body).size).to eq(10)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe 'GET /applications/:application_token' do
        before { get "/applications/#{application_token}" }

        context 'when the record exists' do
            it 'returns the app' do
                expect(JSON.parse(response.body)).not_to be_empty
                expect(JSON.parse(response.body)['token']).to eq(application_token)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the record does not exist' do
            let(:application_token) { 100 }

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end

            it 'returns a not found message' do
                expect(response.body).to match(/Record Not found/)
            end
        end
    end

    describe 'POST /applications/new' do
        let(:valid_attributes) { { name: "new app" } }

        context 'when the request is valid' do
            before { post '/applications/new', params: valid_attributes }

            it 'creates a app' do
                expect(JSON.parse(response.body)['token'].length()).to eq(24)
            end

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
        end

        context 'when the request is invalid' do
            before { post '/applications/new', params: {} }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation failure message' do
                expect(response.body)
                .to match(/Validation failed: Name can't be blank/)
            end
        end
    end

    describe 'PUT /applications/:application_token' do
        let(:valid_attributes) { { name: 'update app' } }

        context 'when the record exists' do
            before { put "/applications/#{application_token}/update", params: valid_attributes }

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end
    end
end
