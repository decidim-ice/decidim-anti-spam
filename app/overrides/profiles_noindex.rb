# frozen_string_literal: true

module ProfilesNoindex
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
                         set_attributes: "meta[name='robots']",
                         attributes: { content: "noindex, nofollow" })
  end
end
