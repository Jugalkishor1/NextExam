ActiveAdmin.register Option do
  menu priority: 5

  permit_params :content, :is_correct, :question_id

  index do
    selectable_column
    id_column
    column :question do |option|
      link_to truncate(option.question.content, length: 60), admin_question_path(option.question)
    end
    column :content
    column :is_correct do |option|
      status_tag(option.is_correct ? "Correct" : "Incorrect")
    end
    actions
  end

  filter :question
  filter :is_correct
  filter :created_at

  form do |f|
    f.inputs 'Option Details' do
      f.input :question, as: :select, collection: Question.all.limit(100)
      f.input :content, as: :text
      f.input :is_correct, as: :boolean
    end
    f.actions
  end
end