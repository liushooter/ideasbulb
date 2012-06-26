class MessageMailer < ActionMailer::Base
  default from: "\"IdeasBulb\" <#{APP_CONFIG['devise_mailer_sender']}>"

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

  def new_idea_email(user,creator,idea)
    @user = user
    @creator = creator
    @idea = idea
    mail to: user.email
  end

  def handle_idea_email(user,idea)
    @user = user
    @idea = idea
    mail to: user.email
  end

end
