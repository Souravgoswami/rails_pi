Rails.application.routes.draw do
  get '*missing', to: 'index#home'
  get 'index/home'
  get 'index/:i/home', to: 'index#home'
  root to: 'index#home'

  patch 'calculate', to: 'index#calculate'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
