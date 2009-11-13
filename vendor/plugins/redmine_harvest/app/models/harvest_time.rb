class HarvestTime < ActiveRecord::Base
  
  # Find the Harvest Project ID for a Redmine project. 
  def self.project_id(project)
    # Find all of the projects that have enabled the "google calendar" plugin
    custom_value = project.custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_harvest['harvest_project_id'].to_i}
    harvest_project_id = custom_value.value.to_i if custom_value
  end
  
  # Find the Harvest User ID for a Redmine user. 
  def self.user_id(user)
    custom_value = user.custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_harvest['harvest_user_id'].to_i}
    harvest_user_id = custom_value.value.to_i if custom_value
  end
end
