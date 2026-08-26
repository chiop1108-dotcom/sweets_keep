Rails.application.routes.draw do
  # 認証機能
  resource :session
  resources :passwords, param: :token

  resources :posts do
      resources :comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
  end
  
  resources :users do
    member do
      # 退会確認画面 (/users/:id/unsubscribe)
      get :unsubscribe 
    end
  end

  # 管理者専用ルーティング
  # namespace :admin do...doでURLの先頭に /admin/ を自動で付与、一般ユーザー用の画面と管理者用の画面を明確に区別
  namespace :admin do
    root to: "users#index"
    resources :users, only: [:index, :destroy] do
      # 権限（一般 ⇔ 管理者）変更用のカスタムルート ( /admin/users/:id/toggle_role )
      # on: :memberを付けることで「特定の一人のユーザー（:id）」を指定して動くルートになる
      patch :toggle_role, on: :member
    end
  end

  # topページ
  root "homes#top"
  # aboutページ 静的なデータ処理を伴わないページ(get)
  get "about", to: "homes#about"
  # mypage
  get "mypage", to: "users#mypage"

  # PostsControllerのsearchアクションに送る
  get "search", to: "posts#search", as: :search

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
