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

  def archiveit_collection_url(collection_id)
    'https://archive-it.org/collections/' + collection_id.to_s
  end
end
