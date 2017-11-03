Rails.application.routes.draw do
  get 'karte/index'
  post 'karte/index'

  resources :leagues, only: [:index, :create]

  get 'leagues/index'

  get 'welcome/index'

  root 'welcome#index'
end
