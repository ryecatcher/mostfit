Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :insurance_policies
  resources :insurance_companies
  resources :occupations
  resources :loan_purposes
  resources :regions do
    resources :areas do
      resources :branches
    end
  end
  resources :areas
  resources :targets
  resources :holidays
  resources :fees
  resources :verifications
  resources :ledger_entries
  resources :loan_products
  resources :users
  resources :staff_members
  resources :clients do
    resources :insurance_policies
  end
  resources :client_groups do
    resources :grts
    resources :cgts
  end
  resources :loans, :id => %r(\d+)
  resources :centers
  resources :branches  do
    resources :centers  do
      resources :client_groups
      resources :clients do
        resources :loans  do
          resources :payments
        end
      end
    end
  end
  resources :funders do
    resources :funding_lines
  end

  match('/design').to(:controller => 'loan_products', :action => 'design').name(:design_loan_product)

  match('/centers/:id/groups(/:group_id).:format').to(:controller => 'centers', :action => 'groups')
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")
  match('/search').to(:controller => 'search', :action => 'index')
  match('/reports/graphs').to(:controller => 'reports', :action => 'graphs')
  match('/reports/:report_type(/:id)').to(:controller => 'reports', :action => 'show').name(:show_report)
  resources :reports

  match('/data_entry').to(:namespace => 'data_entry', :controller => 'index').name(:data_entry)
  namespace :data_entry, :name_prefix => 'enter' do  # for url(:enter_payment) and the likes
    match('/clients(/:action)(/:id)(.:format)').to(:controller => 'clients').name(:clients)
    match('/loans/approve_by_center/:id').to(:controller => 'loans', :action => 'approve').name(:approval_by_center)
    match('/loans(/:action)(.:format)').to(:controller => 'loans').name(:loans)
    match('/payments(/:action)(.:format)').to(:controller => 'payments').name(:payments)
    match('/attendancy(/:action)(.:format)').to(:controller => 'attendancy').name(:attendancy)
    match('/branches(/:action)(/:id)(.:format)').to(:controller => 'branches').name(:branches)
    match('/centers(/:action)(/:id)(.:format)').to(:controller => 'centers').name(:centers)
    match('/groups(/:action)(/:id)(.:format)').to(:controller => 'client_groups').name(:groups)
    match('/client_groups(/:action)(/:id)(.:format)').to(:controller => 'client_groups').name(:groups)
  end

  match('/admin(/:action)').to(:controller => 'admin').name(:admin)
  match('/admin(/:action/:id)').to(:controller => 'admin').name(:admin)
  match('/dashboard(/:action)').to(:controller => 'dashboard').name(:dashboard)

  match('/graph_data/:action(/:id)').to(:controller => 'graph_data').name(:graph_data)
  match('/staff_members/:id/centers').to(:controller => 'staff_members', :action => 'show_centers').name(:show_staff_member_centers)
  match('/branches/:id/today').to(:controller => 'branches', :action => 'today').name(:branch_today)
  match('/entrance(/:action)').to(:controller => 'entrance').name(:entrance)
  match('/branches/:branch_id/centers/:center_id/clients/:client_id/test').to( :controller => 'loans', :action => 'test')
  match('/branches/:branch_id/centers/:center_id/weeksheet').to( :controller => 'centers', :action => 'weeksheet').name(:weeksheet)
  match('/staff_members/:id/day_sheet').to(:controller => 'staff_members', :action => 'day_sheet').name(:day_sheet)
  match('/staff_members/:id/day_sheet.:format').to(:controller => 'staff_members', :action => 'day_sheet', :format => ":format").name(:day_sheet_with_format)
  match('/browse(/:action)').to(:controller => 'browse').name(:browse)
  match('/loans/:action').to(:controller => 'loans').name(:loan_actions)
  # this uses the redirect_to_show methods on the controllers to redirect some models to their appropriate urls
  match('/:controller/:id').to(:action => 'redirect_to_show').name(:quick_link)
  default_routes
  match('/').to(:controller => 'entrance', :action =>'root')
end
