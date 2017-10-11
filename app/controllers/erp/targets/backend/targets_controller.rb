module Erp
  module Targets
    module Backend
      class TargetsController < Erp::Backend::BackendController
        before_action :set_target, only: [:edit, :update, :set_active, :set_deleted]
        before_action :set_targets, only: [:set_active_all, :set_deleted_all]

        # POST /targets/list
        def list
          @targets = Target.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end
    
        # GET /targets/1
        def show
        end
    
        # GET /targets/new
        def new
          @target = Target.new
          
          if request.xhr?
            render '_form', layout: nil, locals: {target: @target}
          end
        end
    
        # GET /targets/1/edit
        def edit
        end
    
        # POST /targets
        def create
          @target = Target.new(target_params)
          @target.creator = current_user

          if @target.save
            @target.set_active
            if request.xhr?
              render json: {
                status: 'success',
                text: @target.id,
                value: @target.id
              }
            else
              redirect_to erp_targets.edit_backend_target_path(@target), notice: t('.success')
            end
          else
            if request.xhr?
              render '_form', layout: nil, locals: {target: @target}
            else
              render :new
            end
          end
        end
    
        # PATCH/PUT /targets/1
        def update
          if @target.update(target_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @target.id,
                value: @target.id
              }
            else
              redirect_to erp_targets.edit_backend_target_path(@target), notice: t('.success')
            end
          else
            render :edit
          end
        end
        
        # Active /targets/status?id=1
        def set_active
          @target.set_active

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        # Delete /targets/status?id=1
        def set_deleted
          @target.set_deleted

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        # Active all /targets/status?ids=1,2..
        def set_active_all
          @target.set_active_all

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
    
        # Deleted all /targets/status?ids=1,2..
        def set_deleted_all
          @target.set_deleted_all

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
          def set_target
            @target = Target.find(params[:id])
          end
          
          def set_targets
            @targets = Target.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def target_params
            params.fetch(:target, {}).permit(:salesperson_id, :period_id, :amount,
                                            :target_details_attributes => [ :id, :percent, :commission_amount, :_destroy ])
          end
      end
    end
  end
end
