class ReportMailer < ApplicationMailer
  default :subject => Proc.new { I18n.t('reports.subject') },
          :to => Proc.new { Rails.configuration.x.report_to }

  def report(report)
    @report = report

    mail
  end
end
