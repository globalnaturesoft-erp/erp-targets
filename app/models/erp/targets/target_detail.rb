module Erp::Targets
  class TargetDetail < ApplicationRecord
    belongs_to :target, class_name: 'Erp::Targets::Target'
  end
end
