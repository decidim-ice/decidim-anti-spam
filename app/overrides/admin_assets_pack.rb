# frozen_string_literal: true

# Add javascript for admin
Deface::Override.new(
  virtual_path: "layouts/decidim/admin/_header",
  name: "admin_spam_signal_javascript_pack",
  insert_before: "erb[loud]:contains('javascript_pack_tag')",
  text: "<%= append_javascript_pack_tag 'admin_decidim_spam_signal' %>"
)

# Add css for admin
Deface::Override.new(
  virtual_path: "layouts/decidim/admin/_header",
  name: "admin_spam_signal_css_pack",
  insert_before: "erb[loud]:contains('stylesheet_pack_tag')",
  text: "<%= append_stylesheet_pack_tag 'admin_decidim_spam_signal_styles' %>"
)

# Add css for frontpage
Deface::Override.new(
  virtual_path: "layouts/decidim/_head",
  name: "spam_signal_css_pack",
  insert_before: "erb[loud]:contains('decidim_overrides')",
  text: "<%= append_stylesheet_pack_tag 'decidim_spam_signal' %>"
)
