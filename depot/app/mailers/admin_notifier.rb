class AdminNotifier < ActionMailer::Base
  default from: "system_error@depot.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_notifier.not_found_error.subject
  #
  def not_found_error(params)
    @params = params

    mail to: "lsimmonds@reachlocal.com", subject: 'Object Access Error Occured'
  end
end
