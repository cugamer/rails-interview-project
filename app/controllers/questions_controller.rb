# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :check_validation

  def show
    render json: question_presenter(question_query(params[:id]))
  end

  def index
    render json: question_presenter(question_query)
  end

  private

  def check_validation
    head :unauthorized unless Tenant.valid_key?(request.headers['HTTP_API_KEY'])
  end

  def question_query(id = nil)
    where_method_params = id ? { private: false, id: id } : { private: false } 
    Question.includes(:user, answers: [:user]).where(where_method_params)
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
