class Api::V1::CollectionsController < Api::V1::ApplicationController
  before_action :authenticate_request!, :only => %w(update)
  load_and_authorize_resource

  before_action :set_collection, :only => %w(show update)

  def index
    theme = Theme.find_by_real_id params[:theme_real_id]

    raise ActiveRecord::RecordNotFound if theme.nil?

    @collections = theme.collections.order(:id).page params[:page]

    render :json => json_response(
      :data => collection_serializing(@collections),
      :meta => pagination_meta(@collections)
    )
  end

  def show
    render :json => json_response(:data => record_serializing(@collection))
  end

  def update
    @collection.update collection_params

    render :json => json_response(
      :success => @collection.valid?,
      :data => record_serializing(@collection),
      :errors => @collection.errors.full_messages
    ),
    :status => (@collection.valid? ? :ok : :bad_request)
  end

  protected

    def set_collection
      @collection = Collection.find_by_real_id params[:real_id]

      raise ActiveRecord::RecordNotFound if @collection.nil?
    end

    def collection_params
      params.require(:collection).permit(:real_id, :name)
    end
end
