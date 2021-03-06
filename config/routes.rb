ActionController::Routing::Routes.draw do |map|
  map.resources(
          :children,
          :collection => { :search => :get, :photo_pdf => :post, :advanced_search => :get } ) do |child|
    child.resource :history, :only => :show
    child.resources :attachments, :only => :show
  end

  map.child_ids "/children-ids", :controller => "child_ids", :action => "all"

  map.child_audio "/children/:child_id/audio/:id", :controller => "child_media", :action => "download_audio"
  map.child_photo "/children/:child_id/photo/:id", :controller => "child_media", :action => "show_photo"
  map.child_resized_photo "/children/:child_id/resized_photo/:size", :controller => "child_media", :action => "show_resized_photo"
  map.child_thumbnail "/children/:child_id/thumbnail/:id", :controller => "child_media", :action => "show_thumbnail"

  map.resources :users
  map.admin 'admin', :controller=>"admin", :action=>"index"
  map.resources :sessions, :except => :index


  map.login 'login', :controller=>'sessions', :action =>'new'
  map.logout 'logout', :controller=>'sessions', :action =>'destroy'


  map.enable_form 'form_section/enable', :controller => 'form_section', :action => 'enable', :value => true, :conditions => {:method => :post}
  map.disable_form 'form_section/disable', :controller => 'form_section', :action => 'enable', :value => false


  map.resources :formsections, :controller=>'form_section' do |form_section|

    field_types = %w{text_field textarea check_box select_drop_down numeric_field}
    additional_field_actions = field_types.inject({}){ |h, type| h["new_#{type}"] = :get; h }
    additional_field_actions[:new] = :get
    additional_field_actions[:move_up] = :post
    additional_field_actions[:move_down] = :post
    additional_field_actions[:delete] = :post
    form_section.resources(
            :fields,
            :controller => 'fields',
            :collection => additional_field_actions )
  end



  map.published_form_sections '/published_form_sections', :controller => 'publish_form_section', :action => 'form_sections'

  map.resources :form_section

  map.resources :fields

  map.root :controller => 'home', :action => :index
end
