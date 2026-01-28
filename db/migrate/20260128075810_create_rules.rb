class CreateRules < ActiveRecord::Migration[8.1]
  def change
    create_table :rules, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :enabled, default: true, null: false
      t.jsonb :when_config, default: {}
      t.jsonb :then_config, default: {}
      t.string :schedule
      t.string :timezone, default: 'UTC'

      t.timestamps
    end
    add_index :rules, :name
  end
end
