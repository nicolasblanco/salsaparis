class EventsController < ApplicationController
  def show
    @event = Event.find_by_slug!(params[:id])
  end
end
