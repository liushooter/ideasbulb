class Preference < ActiveRecord::Base
  def self.option(name)
    preference = Preference.find_by_name(name)
    value = preference ? preference.value : "No Value"
  end
end
