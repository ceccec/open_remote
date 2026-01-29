##
# Create versions table for PaperTrail auditing.
#
class CreateVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :versions do |t|
      t.references :item, type: :uuid, polymorphic: true, null: false, index: { name: "index_versions_on_item" }
      t.string :event, null: false
      t.uuid :whodunnit
      t.jsonb :object
      t.jsonb :object_changes
      t.timestamps
    end

    add_index :versions, :whodunnit
  end
end
