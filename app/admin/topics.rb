ActiveAdmin.register Topic do
  menu priority: 2.5, parent: "Subjects"

  permit_params :name, :description, :subject_id, :status

  index do
    selectable_column
    id_column
    column :name
    column :subject
    column :description do |topic|
      truncate(topic.description, length: 100) if topic.description
    end
    column :questions_count
    column :quizzes do |topic|
      topic.quizzes.count
    end
    column :status do |topic|
      status_tag topic.status
    end
    column :created_at
    actions
  end

  filter :name
  filter :subject
  filter :status, as: :select, collection: Topic.statuses
  filter :created_at

  form do |f|
    f.inputs 'Topic Details' do
      f.input :subject, as: :select, collection: Subject.all.order(:name)
      f.input :name
      f.input :description, as: :text
      f.input :status, as: :select, collection: Topic.statuses.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :subject
      row :description
      row :status do |topic|
        status_tag topic.status
      end
      row :questions_count
      row :created_at
      row :updated_at
    end

    panel "Quizzes" do
      table_for topic.quizzes do
        column :title do |quiz|
          link_to quiz.title, admin_quiz_path(quiz)
        end
        column :difficulty
        column :status
        column :time_limit
        column :questions_count do |quiz|
          quiz.questions.count
        end
      end
      div do
        link_to "Add Quiz for this Topic", new_admin_quiz_path(topic_id: topic.id), class: "button"
      end
    end

    panel "Questions" do
      table_for topic.questions.includes(:options) do
        column :content do |question|
          truncate(question.content, length: 80)
        end
        column :question_type
        column :marks
        column :quiz do |question|
          link_to question.quiz.title, admin_quiz_path(question.quiz) if question.quiz
        end
        column :actions do |question|
          link_to "View", admin_question_path(question), class: "button"
        end
      end
    end
  end

  # Batch action to activate topics
  batch_action :activate do |ids|
    Topic.where(id: ids).update_all(status: :active)
    redirect_to collection_path, notice: "Topics activated!"
  end

  # Batch action to deactivate topics
  batch_action :deactivate do |ids|
    Topic.where(id: ids).update_all(status: :inactive)
    redirect_to collection_path, notice: "Topics deactivated!"
  end
end
