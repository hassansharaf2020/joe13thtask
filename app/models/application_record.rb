class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def base_url
	@base_url =  'http://127.0.0.1:3000/'
  end
end
