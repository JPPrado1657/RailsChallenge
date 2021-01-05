Rails.application.routes.draw do
  resources :systems do
    resources :inputs
      get "inputs/by_number/:number" => 'inputs#by_number'
  end
end