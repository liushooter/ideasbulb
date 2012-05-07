class MessageMailer < ActionMailer::Base
  default from: APP_CONFIG['devise_mailer_sender']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.make_solution_email.subject
  #
  def make_solution_email(user,creator,solution,idea)
    @user = user
    @creator = creator
    @solution = solution
    @idea = idea
    mail to: user.email
  end

  def make_comment_email(user,creator,comment,idea)
    @user = user
    @creator = creator
    @comment = comment
    @idea = idea
    mail to: user.email
  end
end
