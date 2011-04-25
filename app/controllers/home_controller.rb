class HomeController < ApplicationController
  def show
    @events = Event.future.parties
  end

  def courses
    @events = Event.courses
  end
end
