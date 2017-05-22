class AddAttachmentKeyframeToPyramidModules < ActiveRecord::Migration[5.1]
  def self.up
    change_table :pyramid_modules do |t|
      t.attachment :keyframe
    end
  end

  def self.down
    remove_attachment :pyramid_modules, :keyframe
  end
end
