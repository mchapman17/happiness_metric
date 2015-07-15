class GroupsController < ApplicationController

  def show
    group = Group.find(params[:id])
    render json: response_json(group)
  end

  def create
    group = Group.new(group_params.merge(user_id: params[:user_id]))

    if group.save
      group.scores.create!(user_id: params[:user_id], score: 0)
      render json: response_json(group)
    else
      render json: { error: formatted_error_message(group.errors) }, status: 422
    end
  end

  def update
    group = Group.find(params[:id])

    # if group.user_id != params[:user_id]
    #   render json: { error: 'Only group creator can update settings.' }, status: 422
    if group.update(group_params)
      render json: response_json(group)
    else
      render json: { error: formatted_error_message(group.errors) }, status: 422
    end
  end


  private

  def group_params
    params.require(:group).permit(:name, :password, :max_score, :interval, :exclude_score_after_weeks)
    # params.permit(:user_id)
  end

end