ActiveAdmin.register Question do
  menu priority: 4

  permit_params :content, :question_type, :marks, :quiz_id, :exam_id, :subject_id, :topic_id,
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
    column :topic
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
  filter :topic
  filter :quiz
  filter :exam
  filter :created_at

  form do |f|
    f.inputs 'Question Details' do
      f.input :content, as: :text, input_html: { rows: 4 }
      f.input :question_type, as: :select, collection: Question.question_types.keys
      f.input :marks
      f.input :subject, as: :select, collection: Subject.all.order(:name)
      
      f.input :topic, as: :select, 
              collection: f.object.subject_id ? Topic.where(subject_id: f.object.subject_id, status: :active).order(:name) : [],
              include_blank: "Select a topic (optional)",
              hint: "First select a subject to see available topics"
      
      f.input :quiz, as: :select, collection: Quiz.all.order(:title), include_blank: true
      f.input :exam, as: :select, collection: Exam.all.order(:name), include_blank: true
    end

    f.object.options.build if f.object.options.empty?

    f.inputs 'Options' do
      f.has_many :options, allow_destroy: true, new_record: true do |o|
        o.input :content, as: :text, input_html: { style: 'width: 70%; height: 40px;' }
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
      row :topic
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

  # Auto-populate form when coming from quiz page
  controller do
    def new
      @question = Question.new
      @question.quiz_id = params[:quiz_id] if params[:quiz_id]
      if params[:quiz_id]
        quiz = Quiz.find(params[:quiz_id])
        @question.subject_id = quiz.subject_id
        @question.topic_id = quiz.topic_id
      end
      new!
    end
  end
end
