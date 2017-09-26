class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references	:account, index: true, foreign_key: { to_table: :accounts }
      t.references	:photo, index: true, foreign_key: { to_table: :photos }
      t.boolean     :up
      t.timestamps
    end
  end
end
