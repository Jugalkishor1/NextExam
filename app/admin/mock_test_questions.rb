ActiveAdmin.register UserMockTestAttempt do
  menu priority: 8, label: "Mock Test Attempts"

  actions :index, :show, :destroy

  index do
    selectable_column
    id_column
    column :user
    column :mock_test
    column :score
    column :time_taken do |attempt|
      "#{attempt.time_taken / 60} min" if attempt.time_taken
    end
    column :status
    column :started_at
    column :completed_at
    actions
  end

  filter :user
  filter :mock_test
  filter :status, as: :select, collection: UserMockTestAttempt.statuses
  filter :started_at
  filter :completed_at

  show do
    attributes_table do
      row :user
      row :mock_test
      row :score
      row :total_marks do |attempt|
        attempt.mock_test.total_marks
      end
      row :percentage do |attempt|
        total = attempt.mock_test.total_marks
        "#{((attempt.score / total) * 100).round(2)}%" if total > 0
      end
      row :time_taken do |attempt|
        "#{attempt.time_taken} seconds (#{attempt.time_taken / 60} minutes)" if attempt.time_taken
      end
      row :status
      row :started_at
      row :completed_at
      row :created_at
    end

    panel "Answers" do
      table_for user_mock_test_attempt.user_answers.includes(:question, :option) do
        column :question do |answer|
          truncate(answer.question.content, length: 80)
        end
        column :selected_option do |answer|
          answer.option&.content
        end
        column :is_correct do |answer|
          status_tag(answer.is_correct ? "Correct" : "Incorrect", answer.is_correct ? :yes : :no)
        end
        column :marks do |answer|
          answer.is_correct ? answer.question.marks : 0
        end
      end
    end
  end
end