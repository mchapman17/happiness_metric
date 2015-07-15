class ScoresController < ApplicationController

  def create
    group = Group.where('LOWER(name) = ?', params[:group][:name].to_s.downcase).first

    if group && group.authenticate(params[:group][:password])
      score = Score.where(group_id: group.id, user_id: params[:user_id]).first_or_create(score: 0)

      if score.save
        render json: response_json(group)
      else
        render json: { error: formatted_error_message(score.errors) }, status: 422
      end
    else
      render json: { error: "Invalid group or password." }, status: 401
    end
  end

  def update
    group = Group.find(params[:group_id])
    score = group.scores.where(user_id: params[:user_id]).first

    if score.update(score: params[:score].to_f)
      render json: response_json(group)
    else
      render json: { error: formatted_error_message(score.errors) }, status: 422
    end
  end

end