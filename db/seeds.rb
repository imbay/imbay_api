class DropTables < ActiveRecord::Migration[5.1]
    drop_table :sessions, if_exists: true
    drop_table :accounts, if_exists: true
    drop_table :ar_internal_metadata, if_exists: true
    drop_table :schema_migrations, if_exists: true
end
