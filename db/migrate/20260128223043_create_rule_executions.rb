##
# Create rule_executions table.
# Tracks execution history and results for rules.
#
class CreateRuleExecutions < ActiveRecord::Migration[8.1]
  def change
    create_table :rule_executions, id: :uuid do |t|
      t.references :rule, null: false, foreign_key: true, type: :uuid
      t.datetime :executed_at, null: false
      t.string :status, null: false
      t.jsonb :result, default: {}, null: false
      t.text :error_message

      t.timestamps
    end

    # Indexes for queries
    # Note: rule_id index is automatically created by t.references
    add_index :rule_executions, :executed_at
    add_index :rule_executions, :status

    # Partial index for with_errors scope
    add_index :rule_executions, :error_message, where: "error_message IS NOT NULL"

    # Composite index for common query patterns (rule + status + executed_at)
    add_index :rule_executions, [ :rule_id, :status, :executed_at ], name: "index_rule_executions_on_rule_status_executed"
  end
end
