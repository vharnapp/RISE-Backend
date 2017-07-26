class CreateSnippets < ActiveRecord::Migration[5.1]
  def change
    create_table :snippets do |t|
      t.string :name
      t.text :content
      t.datetime :deleted_at
      t.integer :position
      t.string :slug

      t.timestamps
    end
  end
end
