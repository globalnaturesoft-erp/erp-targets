module Erp
  module Targets
    module Backend
      class CompanyTargetsController < Erp::Backend::BackendController
        before_action :set_company_target, only: [:edit, :update, :set_active, :set_deleted]
        before_action :set_company_targets, only: [:set_active_all, :set_deleted_all]
    
        # POST /company_targets/list
        def list
          @company_targets = CompanyTarget.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end
    
        # GET /company_targets/new
        def new
          @company_target = CompanyTarget.new
          
          if request.xhr?
            render '_form', layout: nil, locals: {company_target: @company_target}
          end
        end
    
        # GET /company_targets/1/edit
        def edit
        end
    
        # POST /company_targets
        def create
          @company_target = CompanyTarget.new(company_target_params)
          
          @company_target.creator = current_user

          if @company_target.save
            @company_target.set_active
            if request.xhr?
              render json: {
                status: 'success',
                text: @company_target.name,
                value: @company_target.id
              }
            else
              redirect_to erp_targets.edit_backend_company_target_path(@company_target), notice: t('.success')
            end
          else
            if request.xhr?
              render '_form', layout: nil, locals: {company_target: @company_target}
            else
              render :new
            end
          end
        end
    
        # PATCH/PUT /company_targets/1
        def update
          if @company_target.update(company_target_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @company_target.name,
                value: @company_target.id
              }
            else
              redirect_to erp_targets.edit_backend_company_target_path(@company_target), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # Active /company_targets/status?id=1
        def set_active
          @company_target.set_active

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        # Delete /company_targets/status?id=1
        def set_deleted
          @company_target.set_deleted

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        # Active all /company_targets/status?ids=1,2..
        def set_active_all
          @company_target.set_active_all

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        # Deleted all /company_targets/status?ids=1,2..
        def set_deleted_all
          @company_target.set_deleted_all

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_company_target
            @company_target = CompanyTarget.find(params[:id])
          end
          
          def set_company_targets
            @company_targets = CompanyTarget.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def company_target_params
            params.fetch(:company_target, {}).permit(:name, :period_id, :amount, :bonus_percent)
          end
      end
    end
  end
end
