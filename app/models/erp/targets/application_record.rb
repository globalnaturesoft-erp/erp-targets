module Erp::Targets
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
