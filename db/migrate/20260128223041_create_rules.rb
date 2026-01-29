##
# Create rules table.
# Rules define conditions (when_config) and actions (then_config) for execution.
#
class CreateRules < ActiveRecord::Migration[8.1]
  def change
    create_table :rules, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :enabled, default: true, null: false
      t.jsonb :when_config, default: {}, null: false
      t.jsonb :then_config, default: {}, null: false
      t.string :schedule
      t.string :timezone, default: "UTC", null: false

      t.timestamps
    end

    # Indexes for queries
    add_index :rules, :name
    add_index :rules, :enabled

    # Partial index for with_schedule scope
    add_index :rules, :schedule, where: "schedule IS NOT NULL AND schedule != ''"

    # GIN index for efficient JSONB queries on when_config
    add_index :rules, :when_config, using: :gin, name: "index_rules_on_when_config_gin"
  end
end
