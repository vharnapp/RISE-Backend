class AddAttachmentVideoToPyramidModules < ActiveRecord::Migration[5.1]
  def self.up
    change_table :pyramid_modules do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :pyramid_modules, :video
  end
end
