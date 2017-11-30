module Erp::Targets
  class TargetDetail < ApplicationRecord
    belongs_to :target, class_name: 'Erp::Targets::Target'

    def commission_amount=(new_price)
      self[:commission_amount] = new_price.to_s.gsub(/\,/, '')
    end

    def percent=(new_price)
      self[:percent] = new_price.to_s.gsub(/\,/, '')
    end
  end
end
