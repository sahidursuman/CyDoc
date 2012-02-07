# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Navigation
  def navigation_section(section_title, items = {}, image = "#{title}.png")
    items = items.map {|title, item|
      item = {:controller => item} if item.is_a?(Symbol)
      {:title => title, :url => item}
    }

    render :partial => 'shared/navigation_section', :locals => {:section_title => section_title, :items => items, :image => image}
  end

  # Tabs
  def tab_container(name, heading, tabs)
    render :partial => 'shared/tabs', :locals => {:name => name, :heading => heading, :tabs => tabs}
  end

  def sub_tab_container(type, tabs)
    render :partial => 'shared/sub_tabs', :locals => {:tabs => tabs, :type => type}
  end

  # PDF
  def render_inline_stylesheet(name)
    stylesheet = "<style type='text/css'>\n"
    stylesheet += controller.send(:render_to_string, :file => File.join(RAILS_ROOT, 'public', 'stylesheets', "#{name}.css"))
    stylesheet += "\n</style>\n"
    
    return stylesheet
  end

  # Patient Forms
  def setup_patient(patient)
    patient.tap do |p|
      if p.vcard.nil?
        v = p.build_vcard
      end
      if p.insurance_policies.empty?
        p.insurance_policies.build(:policy_type => "KVG")
        p.insurance_policies.build(:policy_type => "UVG")
      end
    end
  end

 # CRUD helpers
  def icon_edit_link_to(path)
    link_to t_action(:edit), path, :method => :get, :class => 'icon-edit-text', :title => t_action(:edit)
  end

  def icon_delete_link_to(model, path)
    link_to t_action(:delete), path, :remote => true, :method => :delete, :confirm => t_confirm_delete(model), :class => 'icon-delete-text', :title => t_action(:delete)
  end

  # Hozr
  def link_to_hozr(title, path, options = {})
    if Rails.env.development?
      hostname = "hozr-dev"
    else
      hostname = "hozr"
    end

    link_to title, "https://#{hostname}/" + path, options.merge(:target => hostname)
  end
end

