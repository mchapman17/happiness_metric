class ScoresController < ApplicationController

  def update
    @group = Group.find(params[:group_id])
    @score = @group.scores.where(user_id: params[:user_id]).first

    if @score.update(score: params[:score].to_f)
      render json: response_json
    else
      render json: { error: formatted_error_message(@score.errors) }, status: 422
    end
  end

end