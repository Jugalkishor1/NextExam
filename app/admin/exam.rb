ActiveAdmin.register Exam do
  menu priority: 1

  permit_params :name, :description, :exam_type, :status

  index do
    selectable_column
    id_column
    column :name
    column :exam_type
    column :status
    column :mock_tests do |exam|
      exam.mock_tests.count
    end
    column :questions do |exam|
      exam.questions.count
    end
    column :created_at
    actions
  end

  filter :name
  filter :exam_type, as: :select, collection: ['SSC', 'Bank', 'Police', 'Railway']
  filter :status, as: :select, collection: Exam.statuses
  filter :created_at

  form do |f|
    f.inputs 'Exam Details' do
      f.input :name
      f.input :description, as: :text
      f.input :exam_type, as: :select, collection: ['SSC', 'Bank', 'Police', 'Railway'], include_blank: false
      f.input :status, as: :select, collection: Exam.statuses.keys, include_blank: false
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :exam_type
      row :status
      row :created_at
      row :updated_at
    end

    panel "Mock Tests" do
      table_for exam.mock_tests do
        column :title do |mock_test|
          link_to mock_test.title, admin_mock_test_path(mock_test)
        end
        column :status
        column :duration
        column :total_marks
        column :questions_count do |mock_test|
          mock_test.questions.count
        end
      end
      div do
        link_to "Add Mock Test", new_admin_mock_test_path(exam_id: exam.id), class: "button"
      end
    end

    panel "Questions" do
      table_for exam.questions.limit(10) do
        column :content do |question|
          truncate(question.content, length: 100)
        end
        column :question_type
        column :marks
        column :subject
      end
      div do
        link_to "View All Questions", admin_questions_path(q: { exam_id_eq: exam.id }), class: "button"
        link_to "Add Question", new_admin_question_path(exam_id: exam.id), class: "button"
      end
    end
  end
end