class HappinessController < ApplicationController

  def average_group_score
    render json: average_score_json
  end

  def user_score
    group = Group.find(params[:group_id])
    score = Score.first_or_create(group_id: group.id, user_id: params[:user_id])
    score.score = params[:score]
    score.save!

    render json: average_score_json
  end


  private

  def average_score_json
    { average_group_score: average_score(params[:group_id]) }.to_json
  end

  def average_score(group_id)
    scores = Score.where(group_id: group_id)
    score_count = scores.count
    score_total = scores.sum(:score)
    score_count.zero? ? 0 : (score_total / score_count).round(1)
  end

end