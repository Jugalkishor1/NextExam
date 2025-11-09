class PhysicalTestsController < ApplicationController
  # Conversion helpers
  METER_TO_FEET = 3.28084
  FEET_TO_METER = 0.3048

  # Table data (simplified version of your PDF)
  RUNNING_TABLE = [
    { marks: 0, range: 198.3..Float::INFINITY },
    { marks: 1, range: 196.4..198.3 },
    { marks: 2, range: 194.5..196.4 },
    { marks: 3, range: 192.6..194.5 },
    { marks: 4, range: 190.7..192.6 },
    { marks: 5, range: 188.8..190.7 },
    { marks: 6, range: 186.9..188.8 },
    { marks: 7, range: 185.0..186.9 },
    { marks: 8, range: 183.1..185.0 },
    { marks: 9, range: 181.2..183.1 },
    { marks: 10, range: 179.3..181.2 },
    { marks: 11, range: 177.4..179.3 },
    { marks: 12, range: 175.5..177.4 },
    { marks: 13, range: 173.6..175.5 },
    { marks: 14, range: 171.7..173.6 },
    { marks: 15, range: 169.8..171.7 },
    { marks: 16, range: 167.9..169.8 },
    { marks: 17, range: 166.0..167.9 },
    { marks: 18, range: 164.1..166.0 },
    { marks: 19, range: 162.2..164.1 },
    { marks: 20, range: 160.3..162.2 },
    { marks: 21, range: 158.4..160.3 },
    { marks: 22, range: 156.5..158.4 },
    { marks: 23, range: 154.6..156.5 },
    { marks: 24, range: 152.7..154.6 },
    { marks: 25, range: 150.8..152.7 },
    { marks: 26, range: 148.9..150.8 },
    { marks: 27, range: 147.0..148.9 },
    { marks: 28, range: 145.1..147.0 },
    { marks: 29, range: 143.2..145.1 },
    { marks: 30, range: 0..143.2 } # Best time = highest marks
  ]

  LONG_JUMP_TABLE = [
    { marks: 0, range: 0..2.96 },
    { marks: 1, range: 2.96..3.05 },
    { marks: 2, range: 3.05..3.14 },
    { marks: 3, range: 3.14..3.23 },
    { marks: 4, range: 3.23..3.32 },
    { marks: 5, range: 3.32..3.41 },
    { marks: 6, range: 3.41..3.50 },
    { marks: 7, range: 3.50..3.59 },
    { marks: 8, range: 3.59..3.68 },
    { marks: 9, range: 3.68..3.77 },
    { marks: 10, range: 3.77..3.86 },
    { marks: 11, range: 3.86..3.95 },
    { marks: 12, range: 3.95..4.04 },
    { marks: 13, range: 4.04..4.13 },
    { marks: 14, range: 4.13..4.22 },
    { marks: 15, range: 4.22..4.31 },
    { marks: 16, range: 4.31..4.40 },
    { marks: 17, range: 4.40..4.49 },
    { marks: 18, range: 4.49..4.58 },
    { marks: 19, range: 4.58..4.67 },
    { marks: 20, range: 4.67..4.76 },
    { marks: 21, range: 4.76..4.85 },
    { marks: 22, range: 4.85..4.94 },
    { marks: 23, range: 4.94..5.03 },
    { marks: 24, range: 5.03..5.12 },
    { marks: 25, range: 5.12..5.21 },
    { marks: 26, range: 5.21..5.30 },
    { marks: 27, range: 5.30..5.39 },
    { marks: 28, range: 5.39..5.48 },
    { marks: 29, range: 5.48..5.57 },
    { marks: 30, range: 5.57..Float::INFINITY }
  ]

  SHOT_PUT_TABLE = [
    { marks: 0, range: 0..3.83 },
    { marks: 1, range: 3.83..4.00 },
    { marks: 2, range: 4.00..4.17 },
    { marks: 3, range: 4.17..4.34 },
    { marks: 4, range: 4.34..4.51 },
    { marks: 5, range: 4.51..4.68 },
    { marks: 6, range: 4.68..4.85 },
    { marks: 7, range: 4.85..5.02 },
    { marks: 8, range: 5.02..5.19 },
    { marks: 9, range: 5.19..5.36 },
    { marks: 10, range: 5.36..5.53 },
    { marks: 11, range: 5.53..5.70 },
    { marks: 12, range: 5.70..5.87 },
    { marks: 13, range: 5.87..6.04 },
    { marks: 14, range: 6.04..6.21 },
    { marks: 15, range: 6.21..6.38 },
    { marks: 16, range: 6.38..6.55 },
    { marks: 17, range: 6.55..6.72 },
    { marks: 18, range: 6.72..6.89 },
    { marks: 19, range: 6.89..7.06 },
    { marks: 20, range: 7.06..7.23 },
    { marks: 21, range: 7.23..7.40 },
    { marks: 22, range: 7.40..7.57 },
    { marks: 23, range: 7.57..7.74 },
    { marks: 24, range: 7.74..7.91 },
    { marks: 25, range: 7.91..8.08 },
    { marks: 26, range: 8.08..8.25 },
    { marks: 27, range: 8.25..8.42 },
    { marks: 28, range: 8.42..8.59 },
    { marks: 29, range: 8.59..8.76 },
    { marks: 30, range: 8.76..Float::INFINITY }
  ]

  def index; end

  def calculate
    mode = params[:mode]
    result = {}

    if mode == "performance"
      # User enters performance (feet)
      run_time = params[:run_time].to_f
      long_jump_ft = params[:long_jump].to_f
      shot_put_ft = params[:shot_put].to_f

      long_jump_m = long_jump_ft * FEET_TO_METER
      shot_put_m = shot_put_ft * FEET_TO_METER

      result[:running_marks] = RUNNING_TABLE.find { |r| r[:range].include?(run_time) }&.dig(:marks) || 0
      result[:long_jump_marks] = LONG_JUMP_TABLE.find { |r| r[:range].include?(long_jump_m) }&.dig(:marks) || 0
      result[:shot_put_marks] = SHOT_PUT_TABLE.find { |r| r[:range].include?(shot_put_m) }&.dig(:marks) || 0

      result[:total] = result.values.sum
    else
      # User enters marks
      run_marks = params[:run_marks].to_i
      long_marks = params[:long_marks].to_i
      shot_marks = params[:shot_marks].to_i

      result[:required_run] = RUNNING_TABLE.find { |r| r[:marks] == run_marks }&.dig(:range)&.min
      result[:required_long_jump] = (LONG_JUMP_TABLE.find { |r| r[:marks] == long_marks }&.dig(:range)&.min || 0) * METER_TO_FEET
      result[:required_shot_put] = (SHOT_PUT_TABLE.find { |r| r[:marks] == shot_marks }&.dig(:range)&.min || 0) * METER_TO_FEET
      result[:total_marks] = run_marks.to_i + long_marks + shot_marks
    end

    render json: result
  end
end
