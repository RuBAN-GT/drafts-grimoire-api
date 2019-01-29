class Api::V1::ThemesController < Api::V1::ApplicationController
  before_action :authenticate_request!, :only => %w(update)
  load_and_authorize_resource
  
  before_action :set_theme, :only => %w(show update)

  def index
    @themes = Theme.order(:id).page params[:page]

    render :json => json_response(
      :data => collection_serializing(@themes),
      :meta => pagination_meta(@themes)
    )
  end

  def show
    render :json => json_response(:data => record_serializing(@theme))
  end

  def update
    @theme.update theme_params

    render :json => json_response(
      :success => @theme.valid?,
      :data => record_serializing(@theme),
      :errors => @theme.errors.full_messages
    ),
    :status => (@theme.valid? ? :ok : :bad_request)
  end

  protected

    def set_theme
      @theme = Theme.find_by_real_id params[:real_id]

      not_found if @theme.nil?
    end

    def theme_params
      params.require(:theme).permit(:real_id, :name)
    end
end
