CourseSchedulingAssistant::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :rooms
  resources :courses
  resources :times
  resources :instructors
  resources :course_dates
  resources :dates

  resources :sections do
    get 'combine', on: :member
    get 'cross', on: :member
    get 'add_instructor', on: :member
    get 'new/:course_id', to: 'sections#new', on: :collection, as: :new
    patch 'add_instructor', to: 'sections#create', on: :member
    patch 'cross', to: 'sections#create', on: :member
    patch 'combine', to: 'sections#create', on: :member
    get 'edit', to: 'sections#edit', on: :member, as: :edit
    get "update_list", on: :collection, as: :update_list
  end

  # You can have the root of your site routed with "root"
   root 'home#index'
   get 'import' => 'home#import'
   get 'export' => 'home#export'
   post 'import' => 'home#do_import'
   get 'list' => 'home#list'
   delete '/' => 'home#delete_all'





  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
