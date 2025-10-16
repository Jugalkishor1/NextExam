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

    panel "Quizzes" do
      table_for subject.quizzes do
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
        link_to "Add Quiz", new_admin_quiz_path(subject_id: subject.id), class: "button"
      end
    end
  end
end