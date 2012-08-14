# encoding: utf-8
module ApplicationHelper
  def errors_msg_tag(object)
    if object.errors.any?
      content_tag :div,:id =>"alert",:class => "alert alert-block alert-error fade in" do
        list_items = object.errors.full_messages.map { |msg| content_tag(:li, msg) }
        link_to("×","javascript:;",:class =>"close","data-dismiss"=>"alert")+content_tag(:h4,I18n.t("app.error.head"),:class => "alert-heading")+content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  def flash_msg_tag(msg,className)
    if msg
      content_tag :div,:id => "flash-msg" , :class => "alert #{className} fade in" do
        [link_to("×","javascript:;",:class=>"close","data-dismiss"=>"alert"),msg].join.html_safe
      end
    end
  end

  def element_active_tag(element,expectation,actual,options={},&block)
    cssClass ="active "
    cssClass += options[:class] if options[:class]
    options = options.merge(:class => cssClass) if expectation == actual
    content_tag(element,options,&block) 
  end

  def icon_white_tag(expectation,actual,cssClass)
    cssClass = cssClass + " icon-white" if expectation == actual
    content_tag(:i,"",:class => cssClass)
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end
end
