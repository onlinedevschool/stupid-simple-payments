Rails.application.routes.draw do

  unless ::Invoice.table_exists?
    require "#{Rails.root}/db/schema"
  end

  devise_for :invoicers
  authenticated :invoicer do
    root 'invoices#index', as: :authenticated_root
  end

  root to: 'home#index'

  resources :settings

  resources :payees do
    resources :invoices
  end

  resources :invoices do
    resources :payments
  end
end
