# frozen_string_literal: true

Deface::Override.new(
  virtual_path: "decidim/admin/moderated_users/index",
  name: "add_th_flow_to_moderated_users",
  insert_after: "th:has(erb[loud]:contains('t(\".reason\")'))",
  text: "<th class=\"w-[40%] !text-left !pl-4\"><%= t(\"decidim.admin.moderated_users.index.flow\") %></th>"
)

Deface::Override.new(
  virtual_path: "decidim/admin/moderated_users/index",
  name: "add_td_flow_to_moderated_users",
  insert_before: "td:has(erb[loud]:contains('l moderation.created_at, format: :decidim_short'))",
  partial: "decidim/spam_signal/admin/moderated_users/flow_column"
)
