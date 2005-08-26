class Admin::PagesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    list
    render_action 'list'
  end

  def list
    @pages = Page.find(:all, :order => "id DESC")
    @page = Page.new(params[:page])
    @page.text_filter ||= config[:text_filter]
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new(params[:page])
    @page.user_id = session[:user].id
    @page.text_filter ||= config[:text_filter]
    update_html(@page)
    if request.post? and @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to :action => 'show', :id => @page.id
    end
  end

  def edit
    @page = Page.find(params[:id])  
    @page.attributes = params[:page]
    update_html(@page)
    if request.post? and @page.save
      flash[:notice] = 'Page was successfully updated.'
      redirect_to :action => 'show', :id => @page.id
    end      
  end

  def destroy
    @page = Page.find(params[:id])
    if request.post?
      @page.destroy
      redirect_to :action => 'list'
    end
  end
  
  def preview
    @headers["Content-Type"] = "text/html; charset=utf-8"
    @page = Page.new
    @page.attributes = params[:page]
    update_html(@page)
    render :layout => false
  end
  
  private

  def update_html(page)
    page.body_html = filter_text_by_name(page.body, page.text_filter.name) rescue page.body
  end
end
