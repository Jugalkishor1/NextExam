class CreateUserMockTestAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :user_mock_test_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mock_test, null: false, foreign_key: true
      t.decimal :score, precision: 6, scale: 2
      t.integer :time_taken
      t.integer :status, default: 0, null: false
      t.datetime :started_at
      t.datetime :completed_at
      
      t.timestamps
    end
    
    add_index :user_mock_test_attempts, :status
  end
end
