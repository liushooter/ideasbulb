class PreferencesController < ApplicationController
  authorize_resource
  
  def dashboard
    if request.xhr?
      render :layout => false
    else
      render :layout => "admin"
    end
  end
 
  def index
    render :layout => false
  end
  
  def update_basic
    unless params[:preference_site_name].empty?
      @preference_site_name = Preference.find_or_create_by_name(PREFERENCE_SITE_NAME)
      @preference_site_name.value = params[:preference_site_name]
      @preference_site_name.save
      flash.now[:notice] = I18n.t("app.notice.preference.update")
    else
      flash.now[:alert] = I18n.t("app.error.preference.update",:name => I18n.t("app.preference.site_name") ) 
    end
  end
end
