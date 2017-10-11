module Erp
  module Targets
    module Backend
      class TargetDetailsController < Erp::Backend::BackendController
        def target_line_form
          @target_detail = TargetDetail.new

          render partial: params[:partial], locals: {
            target_detail: @target_detail,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
