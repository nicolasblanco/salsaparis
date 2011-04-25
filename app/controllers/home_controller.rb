class HomeController < ApplicationController
  def show
    @events = Event.future.parties.asc(:date_start)
  end

  def courses
    @events = Event.courses.asc(:created_at)
  end
end
