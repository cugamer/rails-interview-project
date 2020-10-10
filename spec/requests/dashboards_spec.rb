require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:question_count) { 3 }
  let(:answers_per_question) { 2 }
  
  before do
    user = FactoryBot.create(:user)
    FactoryBot.create_list(:question, question_count, user: user)
    question_count.times do |n|
      FactoryBot.create_list(:answer, answers_per_question, question_id: n + 1, user: user)
    end
    Question.last.update_attribute(:private, false)
  end

  describe 'GET /dashboard/show' do
    it 'renders the dashboard' do
      get dashboard_show_path

      expect(assigns['counts'][:users]).to eq 1
      expect(assigns['counts'][:questions]).to eq question_count
      expect(assigns['counts'][:answers]).to eq(question_count * answers_per_question)

      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end
end
