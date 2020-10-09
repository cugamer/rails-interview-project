class QuestionsController < ApplicationController
  before_action :check_validation

  def show
    render json: question_presenter(Question.includes(:user, answers: [:user]).where(id: params[:id], private: false))
  end

  def index
    render json: question_presenter(Question.includes(:user, answers: [:user]).where(private: false))
  end

  private

  def check_validation
    head :unauthorized unless Tenant.valid_key?(request.headers['HTTP_API_KEY'])
  end

  def question_presenter(questions)
    output = []
    questions.each do |q|
      answers = q.answers.map { |a| a.as_json.merge(answerer_name: a.user.name, answerer_id: q.user_id) }
      output << q.as_json.merge(asker_name: q.user.name, asker_id: q.user_id, answers: answers)
    end
    output
  end
end
