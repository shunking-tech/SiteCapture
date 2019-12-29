Rails.application.routes.draw do
  root 'captures#new'
  post 'captures/execute' => 'captures#execute'
end
