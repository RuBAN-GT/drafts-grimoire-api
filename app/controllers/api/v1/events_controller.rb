class Api::V1::EventsController < Api::V1::ApplicationController
  def tweets
    client = TwitterWrapper.new
    
    @tweets = Kaminari.paginate_array(
      client.tweets
    ).page(params[:page]).per(params[:per])

    render :json => json_response(
      :data => @tweets
    )
  end
end
