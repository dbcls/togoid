Rails.application.routes.draw do
  # API
  get 'convert', to: 'api#convert', defaults: { format: 'json' }
end
