ActiveAdmin.register Subject do
  menu priority: 2

  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description do |subject|
      truncate(subject.description, length: 100)
    end
    column :topics do |subject|
      subject.topics.count
    end
    column :quizzes do |subject|
      subject.quizzes.count
    end
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs 'Subject Details' do
      f.input :name
      f.input :description, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Topics" do
      table_for subject.topics do
        column :name do |topic|
          link_to topic.name, admin_topic_path(topic)
        end
        column :description do |topic|
          truncate(topic.description, length: 80) if topic.description
        end
        column :status do |topic|
          status_tag topic.status
        end
        column :questions_count
        column :quizzes_count do |topic|
          topic.quizzes.count
        end
      end
      div do
        link_to "Add Topic", new_admin_topic_path(subject_id: subject.id), class: "button"
      end
    end

    panel "Quizzes" do
      table_for subject.quizzes do
        column :title do |quiz|
          link_to quiz.title, admin_quiz_path(quiz)
        end
        column :topic do |quiz|
          link_to quiz.topic.name, admin_topic_path(quiz.topic) if quiz.topic
        end
        column :difficulty
        column :status
        column :time_limit
        column :questions_count do |quiz|
          quiz.questions.count
        end
      end
      div do
        link_to "Add Quiz", new_admin_quiz_path(subject_id: subject.id), class: "button"
      end
    end
  end
end
