Rails.application.routes.draw do
  get 'system_stats', to: 'index#system_stats'
  get 'api_example', to: 'index#api_example'
  get 'index/api_example', to: 'index#api_example'
  get 'index/:digits', to: 'index#render_results', as: 'render_results2'
  get ':digits', to: 'index#render_results', as: 'render_results'
  get '*missing', to: 'index#home'
  get 'index/home'
  root to: 'index#home'

  patch 'calculate', to: 'index#calculate'
end
