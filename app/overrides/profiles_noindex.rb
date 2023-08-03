# frozen_string_literal: true

##
# Snippet for insert the meta tag 'noindex' in the head section of the views listed above
##
views = ["decidim/profiles/show", 
         "decidim/user_activities/index",
         "decidim/user_timeline/index",
         "decidim/user_conversation/index"].freeze

views.each do |view|
  Deface::Override.new(:virtual_path => view,
                       :name => "profiles_noindex",
                       :insert_after => "erb[loud]:contains('cell')",
                       :text => "<% content_for :header_snippets do %><meta name='robots' content='noindex'><% end %>")
end
