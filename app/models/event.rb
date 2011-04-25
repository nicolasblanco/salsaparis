require "net/http"

class Event
  include Mongoid::Document

  field :name
  field :slug

  field :street

  field :event_type, default: "party"

  field :description_fr
  field :description_en

  field :date_start, type: DateTime
  field :date_end, type: DateTime

  field :lat, type: Float
  field :lng, type: Float

  field :facebook_link

  field :dance_style, default: "mixed"

  field :photo_uid

  field :editors, type: Array, default: []

  scope :courses, where(event_type: "course")
  scope :parties, where(event_type: "party")

  scope :for_editor, ->(user) { where(:editors => user.email) }
  scope :future, -> { where(:date_end.gt => Time.now) }

  image_accessor :photo

  validates_presence_of :street, :name
  before_save :do_geocode!
  before_save :generate_slug, on: :create

  def self.find_by_slug!(slug)
    where(:slug => slug).first or raise Mongoid::Errors::DocumentNotFound.new(self, slug)
  end

  def do_geocode!(force = false)
    return unless force || street_changed?
    
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(street)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    self.lat, self.lng = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
  rescue
    false # For now, fail silently...
  end

  def editors_field
    editors.join(", ")
  end

  def editors_field=(str)
    self.editors = str.split(",").map(&:strip)
  end

  def edited_by(user)
    self.editors << user.email unless editors.include?(user.email)
  end

  def party?
    event_type == "party"
  end

  def course?
    event_type == "course"
  end

  def to_param
    slug
  end

  def description(locale)
    send("description_#{locale}")
  end

  protected
  def generate_slug
    self.slug = name.parameterize
  end
end
