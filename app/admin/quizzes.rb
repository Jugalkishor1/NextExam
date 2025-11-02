ActiveAdmin.register Quiz do
  menu priority: 3

  permit_params :title, :description, :subject_id, :topic_id, :difficulty, :time_limit, :status

  index do
    selectable_column
    id_column
    column :title
    column :subject
    column :topic
    column :difficulty
    column :time_limit
    column :status
    column :questions do |quiz|
      quiz.questions.count
    end
    column :created_at
    actions
  end

  filter :title
  filter :subject
  filter :topic
  filter :difficulty, as: :select, collection: Quiz.difficulties
  filter :status, as: :select, collection: Quiz.statuses
  filter :created_at

  form do |f|
    f.inputs 'Quiz Details' do
      f.input :title
      f.input :description, as: :text
      f.input :subject, as: :select, collection: Subject.all.order(:name)
      
      f.input :topic, as: :select, 
              collection: Topic.all.order(:name),
              include_blank: "Select a topic (optional)",
              hint: "First select a subject to see available topics"
      
      f.input :difficulty, as: :select, collection: Quiz.difficulties.keys
      f.input :time_limit, label: "Time Limit (minutes)", input_html: { value: f.object.time_limit || 10 }
      f.input :status, as: :select, collection: Quiz.statuses.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :subject
      row :topic
      row :difficulty
      row :time_limit
      row :status
      row :created_at
      row :updated_at
    end

    panel "Questions" do
      table_for quiz.questions.includes(:options) do
        column :content do |question|
          truncate(question.content, length: 100)
        end
        column :question_type
        column :marks
        column :options do |question|
          question.options.count
        end
        column :actions do |question|
          link_to "View", admin_question_path(question), class: "button"
        end
      end
      div do
        link_to "Add Question", new_admin_question_path(quiz_id: quiz.id), class: "button"
      end
    end
  end

  # Auto-populate form when coming from subject or topic page
  controller do
    def new
      @quiz = Quiz.new
      @quiz.subject_id = params[:subject_id] if params[:subject_id]
      @quiz.topic_id = params[:topic_id] if params[:topic_id]
      new!
    end
  end
end
