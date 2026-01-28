class CreateVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :versions do |t|
      t.references :item, type: :uuid, polymorphic: true, index: true
      t.string     :event, null: false
      t.uuid       :whodunnit, index: true
      t.jsonb      :object
      t.jsonb      :object_changes
      t.timestamps
    end
  end
end
