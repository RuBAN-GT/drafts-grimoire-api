class Api::V1::CardsController < Api::V1::ApplicationController
  before_action :authenticate_request, :only => %w(search index show)
  before_action :authenticate_request!, :only => %w(update read unread)
  load_and_authorize_resource

  before_action :set_card, :only => %w(show update read unread)

  def search
    name = params.require(:q).to_s.downcase

    @cards = Card.where('lower(name) LIKE ?', "%#{name}%")
      .with_translations(I18n.available_locales)
      .order(:name => :asc)
      .page(params[:page])
      .per(20)

    render :json => json_response(
      :data => collection_serializing(@cards, SearchCardSerializer),
      :meta => pagination_meta(@cards)
    )
  end

  def index
    collection = Collection.find_by_real_id(params[:collection_real_id])

    raise ActiveRecord::RecordNotFound if collection.nil?

    @cards = collection.cards.order(:id).page params[:page]

    render :json => json_response(
      :data => collection_serializing(@cards),
      :meta => pagination_meta(@cards)
    )
  end

  def show
    render :json => json_response(:data => record_serializing(@card))
  end

  def update
    @card.update card_params

    render :json => json_response(
      :success => @card.valid?,
      :data => record_serializing(@card),
      :errors => @card.errors.full_messages
    ),
    :status => (@card.valid? ? :ok : :bad_request)
  end

  def read
    current_user.cards << @card unless current_user.cards.include? @card

    render :json => json_response
  end

  def unread
    current_user.cards.delete @card

    render :json => json_response
  end

  protected

    def set_card
      @card = Card.find_by_real_id(params[:real_id] || params[:card_real_id])

      raise ActiveRecord::RecordNotFound if @card.nil?
    end

    def card_params
      params.require(:card).permit(:name, :intro, :description, :glossary, :replacement)
    end
end
