class AddAttachmentKeyframeToPyramidModules < ActiveRecord::Migration
  def self.up
    change_table :pyramid_modules do |t|
      t.attachment :keyframe
    end
  end

  def self.down
    remove_attachment :pyramid_modules, :keyframe
  end
end
