class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def hot_sort
    "(2*`solutions_count`+`comments_count`+`solutions_points`)/POW(TIMESTAMPDIFF(HOUR,`ideas`.`created_at`,NOW())+2,1.5) DESC" 
  end
end
