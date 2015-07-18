class GroupsController < ApplicationController

  def show
    @group = Group.find_by_id(params[:id])

    if @group
      @score = @group.scores.where(user_id: params[:user_id]).first_or_create!(score: 0)
      render json: response_json
    else
      render json: { error: "Group not found." }, status: 404
    end
  end

  def create
    @group = Group.new(group_params.merge(user_id: params[:user_id]))

    if @group.save
      @score = @group.scores.create!(user_id: params[:user_id], score: 0)
      render json: response_json
    else
      render json: { error: formatted_error_message(@group.errors) }, status: 422
    end
  end

  def join
    @group = Group.where('LOWER(name) = ?', params[:group][:name].to_s.downcase).first

    if @group && @group.authenticate(params[:group][:password])
      @score = @group.scores.where(user_id: params[:user_id]).first_or_create!(score: 0)
      render json: response_json
    else
      render json: { error: "Invalid group or password." }, status: 401
    end
  end

  def update
    @group = Group.find(params[:id])
    @score = @group.scores.where(user_id: params[:user_id]).first

    # if @group.user_id != params[:user_id]
    #   render json: { error: 'Only group creator can update settings.' }, status: 422
    if @group.update(group_params)
      render json: response_json
    else
      render json: { error: formatted_error_message(@group.errors) }, status: 422
    end
  end


  private

  def group_params
    params.require(:group).permit(:name, :password, :password_confirmation, :max_score, :interval, :exclude_score_after_weeks)
  end

end