Erp::Targets::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/targets" do
      resources :targets do
        collection do
          post 'list'
          put 'set_active'
          put 'set_deleted'
          put 'set_active_all'
          put 'set_deleted_all'
        end
      end
      resources :target_details do
        collection do
          get 'target_line_form'
        end
      end
      resources :company_targets do
        collection do
          post 'list'
          put 'set_active'
          put 'set_deleted'
          put 'set_active_all'
          put 'set_deleted_all'
        end
      end
    end
  end
end