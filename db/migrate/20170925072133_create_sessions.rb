class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table(:sessions, force: true) do |t|
      t.references	:account, index: true, foreign_key: { to_table: :accounts }
      t.string      :session_key
      t.string      :user_agent, null: true
      t.string      :ip, null: true
      t.integer     :expire_time
      t.timestamps
    end
    add_index :sessions, :session_key,                unique: true
  end
end
