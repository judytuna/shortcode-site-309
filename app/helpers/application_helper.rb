module ApplicationHelper

  def logo
    logo = image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  #return a title on a per-page basis
  def title
    base_title = "POVRay Shortcode Contest"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

end
