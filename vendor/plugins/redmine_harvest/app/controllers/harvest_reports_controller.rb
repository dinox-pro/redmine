class HarvestReportsController < ApplicationController
  helper :sort
  include SortHelper
  unloadable
  
  def index
    Harvest.domain = "squeejee"
    Harvest.email = "jim@squeejee.com"
    Harvest.password = "BigLeague!"
    report = Harvest::Reports.new

    #@entries = report.project_entries(404146, 1.week.ago, Time.now)
    
    sort_init 'created_at', 'desc'
    sort_update 'spent_at' => 'spent_at',
                'user_id' => 'user_id',
                'issue_id' => 'issue_id',
                'hours' => 'hours'
                      
    # HarvestTime.visible_by(User.current) do
      respond_to do |format|
        format.html {
          # Paginate results
          @entry_count = HarvestTime.count()
          @entry_pages = Paginator.new self, @entry_count, per_page_option, params['page']
          @entries = HarvestTime.find(:all, 
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
end
