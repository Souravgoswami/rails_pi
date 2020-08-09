Rails.application.routes.draw do
  get 'api_example', to: 'index#api_example'
  get 'index/api_example', to: 'index#api_example'
  get 'index/:digits', to: 'index#render_results', as: 'render_results2'
  get ':digits', to: 'index#render_results', as: 'render_results'
  get '*missing', to: 'index#home'
  get 'index/home'
  root to: 'index#home'

  patch 'calculate', to: 'index#calculate'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
