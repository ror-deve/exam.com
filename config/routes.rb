require 'sidekiq/web'
Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end
  get 'subjects/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :manage do
    resources :accounts do
      collection do
        get :dashboard
      end
      member do
        put :set_current
      end
      resources :teachers
      resources :batches do
        resources :students do
          collection { post :import }
          collection { get :export }
          get 'download_csv/:file_path', action: :download_csv, on: :collection, as: 'download_csv'
          get :download_sample, on: :collection, defaults: { format: :csv }
        end
      end
      resources :exams do
        resources :papers do
          resources :questions
        end
      end
      resources :subjects do
        resources :topics
      end
    end
  end

  resources :accounts do
    collection do
      get :dashboard
    end
  end
  resources :teachers
  resources :students
  
  resources :batches do
    resources :students
  end
  resources :exams do
    resources :papers do
      resources :exam_sessions, only: [:create]
    end
  end
  resources :exam_sessions, only: [:index, :show]
  resources :paper_sessions, only: [:index] do
    resources :answers, only: [:new, :create]
  end

  devise_for :teachers, path: :teacher, controllers: {
    sessions: 'custom_devise/sessions',
    registrations: 'custom_devise/registrations'
  }
  devise_for :students, path: :student, controllers: {
    sessions: 'custom_devise/sessions',
    registrations: 'custom_devise/registrations'
  }

  resources :students do
    resources :exams do
      resources :papers do
        member do
          get 'start_exam', to: 'papers#start_exam'  # Route to start the exam
          get 'question', to: 'papers#question'
          post 'question', to: 'papers#question'
          post 'exit_exam', to: 'papers#exit_exam'
          get 'score_card', to: 'papers#score_card'
        end
        collection do
          get 'pending', to: 'papers#pending'
          get 'complete', to: 'papers#complete'
        end
      end
    end
  end
  
  get 'teacher/profile', to: 'teachers#profile', as: :teacher_profile
  put 'teacher/change_password', to: 'teachers#change_password'
  post 'teacher/upload_avatar', to: 'teachers#upload_avatar'
  get 'student/profile', to: 'students#profile', as: :student_profile
  put 'student/change_password', to: 'students#change_password'
  post 'student/upload_avatar', to: 'students#upload_avatar'
  get 'teacher/notifications', to: 'teachers#notifications', as: :teacher_notifications
  get 'student/notifications', to: 'students#notifications', as: :student_notifications
  patch 'notifications/:id/mark_as_read', to: 'teachers#mark_as_read', as: :mark_as_read
  
  devise_scope :manage do
    authenticated :teacher do
      root 'manage/accounts#dashboard', as: :teacher_root
    end
  end
  
  root 'accounts#dashboard'
end
