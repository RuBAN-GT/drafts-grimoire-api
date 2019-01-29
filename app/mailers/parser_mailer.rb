class ParserMailer < ApplicationMailer
  default :subject => 'Parser report',
          :to => Proc.new { Rails.configuration.x.report_to }

  def report(cards)
    @cards = cards.is_a?(Array) ? cards : []

    mail
  end
end
