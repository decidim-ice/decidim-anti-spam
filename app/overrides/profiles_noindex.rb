# frozen_string_literal: true

##
# Snippet for insert the meta tag 'noindex' in the head section of the views listed below
# using Deface gem
##
views = ["decidim/profiles/show",
         "decidim/user_activities/index",
         "decidim/searches/index"].freeze

views.each_with_index do |view, index|
  Deface::Override.new(virtual_path: view,
                       name: "profiles_noindex_#{index}",
                       replace_contents: "erb[silent]:contains('content_for :header_snippets do')",
                       closing_selector: "erb[silent]:contains('end')",
                       text: "<meta name=\"robots\" content=\"noindex, nofollow\">")
end
