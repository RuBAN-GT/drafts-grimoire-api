class Api::V1::TooltipsController < Api::V1::ApplicationController
  before_action :authenticate_request!, :only => %w(create update destroy)
  load_and_authorize_resource

  before_action :set_tooltip, :only => %w(show update destroy)

  def index
    @tooltips = Tooltip.order(:slug).page params[:page]

    render :json => json_response(
      :data => collection_serializing(@tooltips),
      :meta => pagination_meta(@tooltips)
    )
  end

  def show
    render :json => json_response(:data => record_serializing(@tooltip))
  end

  def create
    @tooltip = Tooltip.new tooltip_params

    @tooltip.save

    render :json => json_response(
      :success => @tooltip.persisted?,
      :data => record_serializing(@tooltip),
      :errors => @tooltip.errors.full_messages
    ),
    :status => (@tooltip.valid? ? :ok : :bad_request)
  end

  def update
    @tooltip.update tooltip_params

    render :json => json_response(
      :success => @tooltip.valid?,
      :data => record_serializing(@tooltip),
      :errors => @tooltip.errors.full_messages
    ),
    :status => (@tooltip.valid? ? :ok : :bad_request)
  end

  def destroy
    @tooltip.destroy

    render :json => json_response(
      :success => !@tooltip.persisted?,
      :data => record_serializing(@tooltip),
      :errors => @tooltip.errors.full_messages
    ),
    :status => (@tooltip.persisted? ? :bad_request : :ok)
  end

  protected

    def set_tooltip
      @tooltip = Tooltip.find params[:id]
    end

    def tooltip_params
      params.require(:tooltip).permit(:slug, :body, :replacement)
    end
end
