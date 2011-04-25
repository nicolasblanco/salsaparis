module ApplicationHelper
  def markdown(txt)
    Redcarpet.new(txt).to_html.strip[3..-5]
  end
end
