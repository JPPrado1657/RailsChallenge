require 'rails_helper'

RSpec.describe 'Inputs API' do
  # Initialize the test data
  let!(:system) { create(:system) }
  let!(:inputs) { create_list(:input, 20, system_id: system.id) }
  let(:system_id) { system.id }
  let(:id) { input.first.id }

  # Test suite for GET /systems/:system_id/inputs
  describe 'GET /systems/:system_id/inputs' do
    before { get "/systems/#{system_id}/inputs" }

    context 'when system exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all system inputs' do
        expect(json.size).to eq(20)
      end
    end

    context 'when system does not exist' do
      let(:system_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find System/)
      end
    end
  end

  # Test suite for GET /systems/:system_id/inputs/:id
  describe 'GET /systems/:system_id/inputs/:id' do
    before { get "/systems/#{system_id}/inputs/#{id}" }

    context 'when system input exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the input' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when system input does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Input/)
      end
    end
  end

  # Test suite for PUT /systems/:system_id/inputs
  describe 'POST /systems/:system_id/inputs' do
    let(:valid_attributes) { { input: 13, output: [2, 3, 5, 7, 11, 13], validInput: true} }

    context 'when request attributes are valid' do
      before { post "/systems/#{system_id}/inputs", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/systems/#{system_id}/inputs", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Param can't be blank/)
      end
    end
  end

  # Test suite for PUT /systems/:system_id/inputs/:id
  describe 'PUT /systems/:system_id/inputs/:id' do
    let(:valid_attributes) { { input: 10, validInput: false } }

    before { put "/systems/#{system_id}/inputs/#{id}", params: valid_attributes }

    context 'when input exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the input' do
        updated_input = Input.find(id)
        expect(updated_input.input).to match(/10/)
      end
    end

    context 'when the input does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Input/)
      end
    end
  end

  # Test suite for DELETE /systems/:id
  describe 'DELETE /systems/:id' do
    before { delete "/systems/#{system_id}/inputs/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end