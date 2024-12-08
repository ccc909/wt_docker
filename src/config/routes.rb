Rails.application.routes.draw do

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin == true } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: "home#feed"

  devise_for :users
  resources :user_information, only: [:update, :create, :destroy]
  resources :cv, only: [:new, :create, :destroy, :index] do
    member do
      get 'configure_cv'
      post 'create_education'
      post 'create_experience'
      patch 'add_skills'
      patch 'update_experience'
      patch 'update_education'
      delete 'delete_experience'
      delete 'delete_education'
      get 'render_form'
      patch 'pdf_upload'
      patch 'upload_picture'
      delete 'delete_pdf'
      delete 'delete_picture'
    end
  end
  resources :skill, except: [:update, :edit]
  resources :company_information, only: [:destroy, :create, :update] do
    member do
      patch 'add_picture'
      delete 'delete_picture'
    end
  end
  resources :profile, only: [:index] do
    member do
      post 'apply_to_job'
      delete 'cancel_application'
      get 'view_company'
    end
  end
  resources :job, except: [:new] do
    member do
      get 'render_create'
      get 'view_applications'
      get 'view_application_details'
    end
  end
  get '/feed', to: 'home#feed'
  get '/view_job/:id', to: 'home#view_job', as: 'view_job'
  
  get '/index', to: 'admin#index', as: 'admin_index'
  patch '/update_admin/:id', to: 'admin#update_admin', as: 'update_admin'
  patch '/block_user/:id', to: 'admin#block_user', as: 'block_user'
  patch '/enable_company/:id', to: 'admin#enable_company', as: 'enable_company'
  patch '/add_verification_status/:id', to: 'admin#add_verification_status', as: 'add_verification_status'
  get 'show_company_information/:id', to: 'admin#show_company_information', as: 'show_company_information'
  get 'search', to: 'admin#search', as: 'search_users_admin'

end
