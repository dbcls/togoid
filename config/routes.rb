Rails.application.routes.draw do
  root to: 'root#index'

  get 'converter', to: 'converter#converter'
  get 'resolver', to: 'converter#resolver'

  get 'converter/convert', to: 'converter#convert'
  get 'converter/teach', to: 'converter#teach'

  # API
  get 'convert', to: 'api#convert', defaults: { format: 'json' }
end
