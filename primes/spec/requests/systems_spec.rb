require 'rails_helper'

RSpec.describe 'Systems API', type: :request do
  # initialize test data
  let!(:systems) { create_list(:system, 10) }
  let(:system_id) { systems.first.id }

  # Test suite for GET /systems
  describe 'GET /systems' do
    # make HTTP get request before each example
    before { get '/systems' }

    it 'returns systems' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /systems/:id
  describe 'GET /systems/:id' do
    before { get "/systems/#{system_id}" }

    context 'when the record exists' do
      it 'returns the system' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(system_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:system_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find System/)
      end
    end
  end

  # Test suite for POST /systems
  describe 'POST /systems' do
    # valid payload
    let(:valid_attributes) { { name: 'Jaime Rodríguez' } }

    context 'when the request is valid' do
      before { post '/systems', params: valid_attributes }

      it 'creates a system' do
        expect(json['name']).to eq('Jaime Rodríguez')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/systems', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /systems/:id
  describe 'PUT /systems/:id' do
    let(:valid_attributes) { { name: 'Juan González' } }

    context 'when the record exists' do
      before { put "/systems/#{system_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /systems/:id
  describe 'DELETE /systems/:id' do
    before { delete "/systems/#{system_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end