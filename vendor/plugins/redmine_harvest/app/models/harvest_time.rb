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
  
  def self.import_time(project)
    harvest_project_id = self.project_id(project)
    # From date of last job for project;  Default to 1 year ago.
    from_date = HarvestTime.minimum(:created_at, :conditions=>{:project_id => project.id}) || 1.year.ago
    to_date = Time.now
    
    harvest_user_custom_field_id = Setting.plugin_redmine_harvest['harvest_user_id']
    
    Harvest.report.project_entries(harvest_project_id, from_date, to_date).each do |entry|
      entry.project_id = project.id
      
      # Find the Redmine user id through the CustomValue data
      user_custom_value = CustomValue.find_by_value_and_custom_field_id(entry.user_id, harvest_user_custom_field_id)
      entry.user_id = user_custom_value ? user_custom_value.customized.id : nil

    end
    
    
  end
end
