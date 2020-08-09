Rails.application.routes.draw do
  get 'index/home'
  patch 'calculate', to: 'index#calculate'
  root to: 'index#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
