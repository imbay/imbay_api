class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references	:account, index: true, foreign_key: { to_table: :accounts }
      t.references	:photo, index: true, foreign_key: { to_table: :photos }
      t.string      :text
      t.timestamps
    end
  end
end
