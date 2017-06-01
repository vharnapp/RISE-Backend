class RenameTrackDisplayTrack < ActiveRecord::Migration[5.1]
  def change
    rename_column :pyramid_modules, :track, :display_track
    add_column :pyramid_modules,   :tracks, :text, array:true, default: []
  end
end
