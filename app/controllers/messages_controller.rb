class MessagesController < ApplicationController
  authorize_resource

  def show
    message = current_user.messages.find(params[:id])
    message.readed = true
    message.save
    redirect_to message.link
  end
end
