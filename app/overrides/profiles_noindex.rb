# frozen_string_literal: true

##
# Snippet for insert the meta tag 'noindex' in the head section of the views listed below
# using Deface gem
##
views = ["decidim/profiles/show",
         "decidim/user_activities/index",
         "decidim/user_timeline/index",
         "decidim/user_conversation/index"].freeze

views.each do |view|
  Deface::Override.new(virtual_path: view,
                       name: "profiles_noindex",
                       insert_after: "erb[loud]:contains('cell \"decidim/profile\"')",
                       text: "<% content_for :header_snippets do %><meta name='robots' content='noindex,nofollow'><% end %>")
end
