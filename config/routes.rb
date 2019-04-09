Rails.application.routes.draw do
  root to: 'root#index'

  # API
  get 'convert', to: 'api#convert', defaults: { format: 'json' }
end
