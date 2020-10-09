class DashboardController < ApplicationController
  def show
    @counts = object_counts
    @tenants = Tenant.all
  end

  private

  def object_counts
    counts = {
      users: User.count,
      questions: Question.count,
      answers: Answer.count
    }
  end
end
