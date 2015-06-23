class HappinessController < ApplicationController

  def join_group
    group = Group.where('LOWER(name) = ?', params[:group][:name].to_s.downcase).first

    if group
      if group.authenticate(params[:group][:password])
        render json: group_json(group)
      else
        render json: { error: "Invalid group or password." }, status: 422
      end
    else
      render json: { error: "Invalid group or password." }, status: 422
    end
  end

  def create_group
    puts "params: #{group_params.merge(user_id: params[:user_id])}"
    group = Group.new(group_params.merge(user_id: params[:user_id]))

    if group.save
      render json: group_json(group)
    else
      render json: { error: error_message(group.errors) }, status: 422
    end
  end

  def update_group
    group = Group.find(params[:group_id])

    # if group.user_id != params[:user_id]
    #   render json: { error: 'Only group creator can update settings.' }, status: 422
    if group.update(group_params)
      render json: group_json(group)
    else
      render json: { error: error_message(group.errors) }, status: 422
    end
  end

  def group
    group = Group.find(params[:group_id])
    render json: group_json(group)
  end

  def update_user_score
    group = Group.find(params[:group_id])
    set_user_score(group, params[:score].to_f)

    render json: group_json(group)
  end


  private

  def group_json(group)
    {
      group: {
        id: group.id,
        name: group.name,
        min_score: group.min_score,
        max_score: group.max_score,
        interval: group.interval,
        average_score: group_average_score(group.id),
        user_count: group_user_count(group.id)
      },
      user: {
        score: user_score(group).score
      }
    }.to_json
  end

  def set_user_score(group, new_score)
    score = user_score(group)
    score.score = new_score
    score.save!
    score
  end

  def user_score(group)
    score = Score.where(group_id: group.id, user_id: params[:user_id]).first_or_initialize(score: 0)
    score
  end

  def group_average_score(group_id)
    Score.where(group_id: group_id).average(:score).to_f.round(2)
  end

  def group_user_count(group_id)
    Score.where(group_id: group_id).count
  end

  def group_params
    params.require(:group).permit(:name, :password, :max_score, :interval, :exclude_score_after_weeks)
    # params.permit(:user_id)
  end

  def error_message(errors)
    errors.full_messages.join(", ") + '.'
  end

end