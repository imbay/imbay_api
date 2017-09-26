class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.references	:account, index: true, foreign_key: { to_table: :accounts }
      t.integer     :views, default: 0
      t.integer     :likes, default: 0
      t.integer     :dislikes, default: 0
      t.integer     :comments, default: 0
      t.integer     :new_comments, default: 0
      t.binary      :content
      t.timestamps
    end
  end
end
