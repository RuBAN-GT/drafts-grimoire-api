require "rails_helper"

RSpec.describe ParserMailer, :type => :mailer do
  describe 'reports of parser' do
    let(:mail) { ParserMailer.report(['Test']) }

    it 'renders the body' do
      expect(mail.body.encoded).to be_a(String)
      expect(mail.body.encoded.empty?).to be_falsey
      expect(mail.body.encoded.include?('Test')).to be_truthy
    end
  end
end
