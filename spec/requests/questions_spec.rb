require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let(:tenant) { FactoryBot.create(:tenant) }
  let(:question_count) { 3 }
  let(:answers_per_question) { 2 }

  before do
    user = FactoryBot.create(:user)
    FactoryBot.create_list(:question, question_count, user_id: user.id)
    question_count.times do |n|
      FactoryBot.create_list(:answer, answers_per_question, question_id: n + 1)
    end
    Question.last.update_attribute(:private, false)
  end

  describe "GET /questions" do
    context 'with valid API key' do
      it 'returns a correct JSON response' do
        total_public = Question.where(private: false).count
        
        headers = { 'HTTP_API_KEY' => tenant.api_key }
        get questions_path, {}, headers

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq total_public
        expect(JSON.parse(response.body).first['answers'].length).to eq answers_per_question
      end
    end

    context 'without valid API key' do
      it 'returns a 401 response' do
        headers = { 'HTTP_API_KEY' => 'badapikey' }
        get questions_path, {}, headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /questions/:id" do
    context 'with valid API key' do
      it 'returns a correct JSON response' do        
        headers = { 'HTTP_API_KEY' => tenant.api_key }
        get question_path(Question.last.id), {}, headers

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq 1
        expect(JSON.parse(response.body).first['answers'].length).to eq answers_per_question
      end
    end

    context 'without valid API key' do
      it 'returns a 401 response' do
        headers = { 'HTTP_API_KEY' => 'badapikey' }
        get question_path(Question.last.id), {}, headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
