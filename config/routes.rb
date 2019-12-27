Rails.application.routes.draw do
  root 'captures#new'
  get 'captures/execute' => 'captures#execute'
end
