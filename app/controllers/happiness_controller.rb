class HappinessController < ApplicationController

  def join_group
    group = Group.find_by_name(params[:group_name])

    if group
      if group.authenticate(params[:password])
        render json: group_json(group)
      else
        render json: { error: "Invalid group or password." }
      end
    else
      render json: { error: "Invalid group or password." }
    end
  end

  def create_group
    group = Group.new(name: params[:group_name], password: params[:password], user_id: params[:user_id])

    if group.save
      render json: group_json(group)
    else
      render json: { error: group.errors }
    end
  end

  def get_group
    group = Group.find(params[:group_id])
    render json: group_json(group)
  end

  def update_user_score
    group = Group.find(params[:group_id])
    score = Score.where(group_id: group.id, user_id: params[:user_id])
    update_user_score_for_group(group: group, user_id: params[:user_id], score: params[:score].to_f)

    render json: average_score_json
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
        average_score: calculate_group_average_score(group.id),
        user_count: calculate_group_user_count(group.id)
      },
      user: {
        score: user_score(group)
      }
    }.to_json
  end

  def average_score_json
    {
      group_average_score: calculate_group_average_score(params[:group_id]),
      group_user_count: calculate_group_user_count(params[:group_id])
    }.to_json
  end

  def user_score(group)
    score = Score.where(group_id: group.id, user_id: params[:user_id]).first_or_initialize(score: 0).save!
    puts "--- user score: #{score.to_f}"
    score.score
  end

  def calculate_group_average_score(group_id)
    scores = Score.where(group_id: group_id)
    score_count = scores.count
    score_total = scores.sum(:score)
    s = score_count.zero? ? 0 : (score_total / score_count).round(2)
    puts "--- average group score: #{s}"
    s
  end

  def calculate_group_user_count(group_id)
    Score.where(group_id: group_id).count
  end

end