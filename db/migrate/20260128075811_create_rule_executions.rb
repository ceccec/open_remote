class CreateRuleExecutions < ActiveRecord::Migration[8.1]
  def change
    create_table :rule_executions, id: :uuid do |t|
      t.references :rule, null: false, foreign_key: true, type: :uuid
      t.datetime :executed_at, null: false
      t.string :status, null: false
      t.jsonb :result, default: {}
      t.text :error_message

      t.timestamps
    end
    add_index :rule_executions, :executed_at
    add_index :rule_executions, :status
  end
end
