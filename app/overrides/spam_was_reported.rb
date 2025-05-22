# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/_wrapper",
                     name: "spam_was_reported_class",
                     set_attributes: "div.layout-container",
                     attributes: { class: <<~ERB
                       layout-container<% if spam_reported? %> spam-reported <%= spam_actions_performed.map {|a| "spam-reported--#{a}"}.join(" ") %><% end %>
                     ERB
                     })
