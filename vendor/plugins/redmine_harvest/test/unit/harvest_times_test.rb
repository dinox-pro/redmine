require File.dirname(__FILE__) + '/../test_helper'

class HarvestTimesTest < ActiveSupport::TestCase
  
  context "When using the TimeTracking API" do
    setup do
      Harvest.domain = 'testing'
      Harvest.email =  'test@example.com'
      Harvest.password = 'OU812'
      Harvest.report = Harvest::Reports.new
    end

    should "retrieve project entries for a time range as string values" do
      url = /http:\/\/test%40example.com:OU812@testing.harvestapp.com\/projects\/408960\/entries.*/
      stub_get url, 'harvest_project_entries.xml'
      harvest_project_id = "408960"      
      cf = CustomField.make(:name => "Harvest Project Id" )
      Setting.plugin_redmine_harvest['harvest_project_id'] = cf.id
      project = Project.first
      cv = CustomValue.make(:customized_type => "Project", :customized_id => project.id, :custom_field_id => cf.id, :value => harvest_project_id)
      
      HarvestTime.import_time(project)
      assert HarvestTime.find(14316565).hours == 4.5
    end
  end
end
