# encoding: UTF-8

TtRegister::Application.routes.draw do
  root to: 'inscriptions#new'
  resources :inscription_players
  match 'inscription_players/add_player' => "inscription_players#add_player"
  match 'inscription_players/update_series' => "inscription_players#update_series"
  match 'inscription_players/player/:id' => "inscription_players#player"
  match 'inscriptions/logout', :controller => 'inscriptions', :action => 'logout', :as => :logout
  resources :inscriptions
  match 'inscriptions/select_player/:id' => 'inscriptions#select_player'
  match 'inscriptions/:id/:token' => 'inscriptions#login', :as => 'login'
  match 'resend_link' => 'inscriptions#resend_link', :as => 'resend_link'
  match 'resend' => 'inscriptions#resend', :as => 'resend'
  match 'email_form' => 'inscriptions#email_form' , :as => 'email_form'
  match 'mail_team' => 'inscriptions#mail_team', :as => 'mail_team'
  match 'protection' => 'inscriptions#protection', :as => 'protection'
  match 'admins/verify_login' => 'admins#verify_login', :as => 'connect'
  match 'admins/logoff' => 'admins#logoff', :as => 'logoff_admin'
  resources :admins
  match 'inscription_players/enroll' => 'inscription_players#enroll', :via => :post
  resources :tournament_days
  match 'tournament_days/copy_series' => 'tournament_days#copy_series', :as => 'copy_day'
  resources :tournaments
  resources :series
  resources :players
  match 'players/filtered' => 'players#filtered'
  match 'players/upload' => 'players#upload', via: :post
  match 'auto.:format' => 'players#auto', as: 'auto'
  match 'tournaments/entries/:id.:format' => 'tournaments#download_entries', :as => 'tournament_entries'
  match 'tournaments/delete_inscriptions/:id' => 'tournaments#delete_all_inscriptions', :as => 'delete_all_inscriptions'

  match 'inscriptions/new' => 'inscritions#new', as:'new_inscription'
  match 'admins/login/:token' => 'admins#login', via: :get
  match 'series/:id/players' => 'series#players', :as => :series_players

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
