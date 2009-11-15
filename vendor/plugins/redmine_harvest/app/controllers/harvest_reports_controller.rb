class HarvestReportsController < ApplicationController
  helper :sort
  include SortHelper
  unloadable
  
  before_filter :find_project, :authorize
  
  def index    
    sort_init 'created_at', 'desc'
    sort_update 'spent_at' => 'spent_at',
                'user' => 'user_id',
                'issue' => 'issue_id',
                'hours' => 'hours'
                
    cond = ARCondition.new
    cond << ['project_id = ?', @project.id]
    
    # retrieve_date_range
    # cond << ['spent_on BETWEEN ? AND ?', @from, @to]
                      
    # HarvestTime.visible_by(User.current) do
      respond_to do |format|
        format.html {
          # Paginate results
          @entry_count = HarvestTime.count(:include => :project, :conditions => cond.conditions)
          @entry_pages = Paginator.new self, @entry_count, per_page_option, params['page']
          @entries = HarvestTime.find(:all, 
                                    :include => [:project, :user], 
                                    :conditions => cond.conditions,
                                    :order => sort_clause,
                                    :limit  =>  @entry_pages.items_per_page,
                                    :offset =>  @entry_pages.current.offset)
          @total_hours = HarvestTime.sum(:hours).to_f

          render :layout => !request.xhr?
        }
      end
    # end
  end

  def show
  end
  
  
  private
    def find_project   
      @project = Project.find(params[:project_id])
    end
end
