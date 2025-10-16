ActiveAdmin.register Question do
  menu priority: 4

  permit_params :content, :question_type, :marks, :quiz_id, :exam_id, :subject_id,
                options_attributes: [:id, :content, :is_correct, :_destroy]

  index do
    selectable_column
    id_column
    column :content do |question|
      truncate(question.content, length: 80)
    end
    column :question_type
    column :marks
    column :subject
    column :quiz
    column :exam
    column :options do |question|
      question.options.count
    end
    actions
  end

  filter :content
  filter :question_type, as: :select, collection: Question.question_types
  filter :subject
  filter :quiz
  filter :exam
  filter :created_at

  form do |f|
    f.inputs 'Question Details' do
      f.input :content, as: :text, input_html: { rows: 4 }
      f.input :question_type, as: :select, collection: Question.question_types.keys
      f.input :marks
      f.input :subject, as: :select, collection: Subject.all.order(:name)
      f.input :quiz, as: :select, collection: Quiz.all.order(:title), include_blank: true
      f.input :exam, as: :select, collection: Exam.all.order(:name), include_blank: true
    end

    f.inputs 'Options' do
      f.has_many :options, allow_destroy: true, new_record: true do |o|
        o.input :content
        o.input :is_correct, as: :boolean
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :content
      row :question_type
      row :marks
      row :subject
      row :quiz
      row :exam
      row :created_at
      row :updated_at
    end

    panel "Options" do
      table_for question.options do
        column :content
        column :is_correct do |option|
          status_tag(option.is_correct ? "Correct" : "Incorrect")
        end
      end
    end
  end
end