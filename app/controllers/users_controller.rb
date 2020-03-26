class UsersController < ApplicationController
  load_resource
  authorize_resource except: [:analytics_alias]
  skip_authorization_check only: [:analytics_alias]

  def analytics_alias
    # view file has JS that will identify the anonymous user through segment
    # after registration via "after devise registration path"
  end

	def unlock_modules_for_club_players
	  render_text = "test"
	  unlock_pyramid_module_values = Array.new
	  today = Date.today

	  page = params[:page].nil? ? 0 : params[:page].to_i
	  limit = 500
	  offset = page * limit

		render_text = ""

	  pyramid_modules = PyramidModule.select("id,name").where(id: [3,5,7,8,9,10,11,12,13,15,16,17]).order(:id)

	  affiliations = Affiliation.joins(:user).select("affiliations.id, affiliations.user_id, users.email as user_email").where(deleted_at: nil).where(team_id: 149).offset(offset).limit(limit)
	  aux = 0
	  affiliations.each do |affiliation|
	  	aux = 0
	  	pyramid_modules.each do |pyramid_module|
	  		if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: affiliation.user_id).empty? 
          unlock_pyramid_module_values << "(#{affiliation.user_id},#{pyramid_module.id},'{}','2020-03-25 01:23:45','2020-03-25 01:23:45')"
          aux = 1
        end
	  	end
      if (aux == 1)
	  		render_text += "#{affiliation.user_email} \n"
	  	end
	  end


    if (unlock_pyramid_module_values.count > 0)
      unlock_complete_training_modules_sql = "INSERT INTO unlocked_pyramid_modules (user_id, pyramid_module_id, completed_phases, created_at, updated_at) VALUES #{unlock_pyramid_module_values.join(',')};"
      ActiveRecord::Base.connection.execute(unlock_complete_training_modules_sql)
    end

	  render plain: render_text
	end
end
