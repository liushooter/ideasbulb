module MessagesHelper
  def message_link_tag(message)
    if message.readed 
      message_class_link_tag(message,"message")   
    else
      message_class_link_tag(message,"message bold")   
    end
  end

  def message_class_link_tag(message,cssClass)
    link_to message_path(message),:class=>cssClass do
      content_tag(:span,message.content)+content_tag(:span,distance_of_time_in_words_to_now(message.created_at),:class=>"shallow",:style=>"float:right")
    end
  end
end
