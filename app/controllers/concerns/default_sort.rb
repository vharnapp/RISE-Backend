module DefaultSort
  extend ActiveSupport::Concern

  included do
    before_action :default_params
  end

  def sort
    # model = controller_name.classify.constantize

    ids = params[:ids]
    sortable_model = params[:sortable_model].classify.constantize rescue nil
    resource_model = params[:resource_model].classify.constantize rescue nil
    parent_model = params[:parent_model].classify.constantize rescue nil
    parent_model_id = params[:parent_model_id]

    if sortable_model != resource_model # hmt sort
      # FIXME: (2017-05-28) jon => n+1...I'd like to embed the association ids in the DOM so I can just send them along...
      ids = ids.map do |id|
        sortable_model.where({"#{parent_model.to_s.underscore}_id" => parent_model_id}).where({"#{resource_model.to_s.underscore}_id" => id}).first.id
      end
    end

    ids.each_with_index do |id, index|
      sortable_model.where(id: id).update(position: index + 1)
    end

    head :ok
  end

  def default_params
    params[:order] ||= 'position'
    params[:direction] ||= 'asc'
  end
end
