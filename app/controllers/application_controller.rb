class ApplicationController < ActionController::API

  protected

  def response_json
    {
      group: {
        id: @group.id,
        name: @group.name,
        min_score: @group.min_score,
        max_score: @group.max_score,
        interval: @group.interval,
        exclude_score_after_weeks: @group.exclude_score_after_weeks,
        average_score: @group.average_score,
        score_count: @group.included_scores.count
      },
      score: {
        id: @score.id,
        score: @score.score
      }
    }.to_json
  end

  def formatted_error_message(errors)
    "#{errors.full_messages.join(", ")}."
  end

end
