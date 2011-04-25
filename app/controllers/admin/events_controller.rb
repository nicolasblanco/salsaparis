class Admin::EventsController < Admin::AdminController
  before_filter :load_model, :only => %w(show edit update destroy)

  protected
  def load_model
    @event = current_user.events.find_by_slug!(params[:id])
  end

  public
  def index
    @events = current_user.events.paginate(page: params[:page])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.edited_by(current_user)
    
    if @event.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @event.attributes = params[:event]
    @event.edited_by(current_user)

    if @event.save
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @event.destroy

    redirect_to action: 'index'
  end
end
