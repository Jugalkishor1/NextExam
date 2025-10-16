ActiveAdmin.register MockTest do
  menu priority: 6

  permit_params :title, :description, :exam_id, :duration, :total_marks, :status

  index do
    selectable_column
    id_column
    column :title
    column :exam
    column :duration
    column :total_marks
    column :status
    column :questions do |mock_test|
      mock_test.questions.count
    end
    column :created_at
    actions
  end

  filter :title
  filter :exam
  filter :status, as: :select, collection: MockTest.statuses
  filter :created_at

  form do |f|
    f.inputs 'Mock Test Details' do
      f.input :title
      f.input :description, as: :text
      f.input :exam, as: :select, collection: Exam.all.order(:name)
      f.input :duration, label: "Duration (minutes)"
      f.input :status, as: :select, collection: MockTest.statuses.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :exam
      row :duration
      row :total_marks
      row :status
      row :created_at
      row :updated_at
    end

    panel "Questions" do
      table_for mock_test.mock_test_questions.includes(question: :options).order(:order) do
        column :order
        column :content do |mtq|
          truncate(mtq.question.content, length: 100)
        end
        column :question_type do |mtq|
          mtq.question.question_type
        end
        column :marks do |mtq|
          mtq.question.marks
        end
        column :subject do |mtq|
          mtq.question.subject&.name
        end
        column :actions do |mtq|
          link_to "Remove", remove_question_admin_mock_test_path(mock_test, question_id: mtq.question_id), 
                  method: :delete, 
                  data: { confirm: "Are you sure?" },
                  class: "button"
        end
      end
    end
  end

  member_action :remove_question, method: :delete do
    mock_test_question = resource.mock_test_questions.find_by(question_id: params[:question_id])
    mock_test_question&.destroy
    resource.update(total_marks: resource.calculate_total_marks)
    redirect_to admin_mock_test_path(resource), notice: "Question removed successfully"
  end

  member_action :add_questions, method: :post do
    question_ids = params[:question_ids] || []
    last_order = resource.mock_test_questions.maximum(:order) || 0
    
    question_ids.each_with_index do |question_id, index|
      next if question_id.blank?
      resource.mock_test_questions.create(
        question_id: question_id,
        order: last_order + index + 1
      )
    end
    
    resource.update(total_marks: resource.calculate_total_marks)
    redirect_to admin_mock_test_path(resource), notice: "Questions added successfully"
  end
end
