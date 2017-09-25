class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table(:sessions, id: false, force: true) do |t|
      t.references	:account, index: true, foreign_key: { to_table: :accounts }
      t.string      :key
      t.string      :user_agent, null: true
      t.string      :ip, null: true
      t.integer     :expire_time
      t.timestamps
    end
    add_index :sessions, :key,                unique: true
  end
end
