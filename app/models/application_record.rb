class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  WillPaginate.per_page = 10
end
