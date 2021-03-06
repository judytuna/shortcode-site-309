module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "POVRay Shortcode Contest", :class => "round logo")
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
  
  def time_between(timea, timeb)
    difference = (timea - timeb).to_i
    if difference < 0
      difference *= -1
    end
    
  	seconds    =  difference % 60
	difference = (difference - seconds) / 60
	minutes    =  difference % 60
	difference = (difference - minutes) / 60
	hours      =  difference % 24
	difference = (difference - hours)   / 24
	days       =  difference
	
	result = ""
	
	if (days > 0)
	  result << pluralize(days, 'day')
	end
	
	if (days < 2)
	  if (hours > 0)
        result << ' ' << pluralize(hours, 'hour')
      end
	end
	
	if (hours < 1)
	  if (minutes > 0)
        result << ' ' << pluralize(minutes, 'minute')
      end
      
      result << ' ' << pluralize(seconds, 'second')
	end
	
    return result
  end

end

