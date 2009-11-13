require 'redmine'
require 'harvestr'

Redmine::Plugin.register :redmine_harvest do
  name 'Redmine Harvest plugin'
  author 'Jim Mulholland'
  description 'This is a plugin for Redmine to import project timesheet data from Harvest.'
  version '0.0.1'
end
