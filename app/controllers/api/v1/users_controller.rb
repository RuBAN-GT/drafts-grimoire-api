class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_user

  def show
    render :json => json_response(:data => record_serializing(@user))
  end

  protected

    def set_user
      @user = User.find(params[:id] || params[:user_id])

      unless @user == current_user
        render :json => json_response(
          :success => false,
          :errors => I18n.t('authorization.forbidden')
        ),
        :status => :forbidden
      end
    end
end
