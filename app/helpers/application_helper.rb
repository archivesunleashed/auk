# frozen_string_literal: true

# Application helper.
module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Archives Unleashed'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
