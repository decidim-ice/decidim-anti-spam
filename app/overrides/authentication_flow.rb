# frozen_string_literal: true

# DEVISE SCREENS
############################################################

Deface::Override.new(virtual_path: "layouts/decidim/shared/_layout_center",
                     name: "authentication_flow_devise",
                     surround_contents: "erb[loud]:contains('main_tag')",
                     closing_selector: "erb[silent]:contains('end')",
                     text: <<~ERB
                       <% if spam_reported?(:hide_authentication) && spam_reported? %>
                         <div>
                             <h1 class="title-decorator my-12"><%= t("title", scope: "decidim.spam_signal.devise.forbidden_page") %></h1>
                             <div class="login__info font-semibold">
                               <%= spam_errors.any? ? spam_errors.messages[:page].join(",") : t("default_message", scope: "decidim.spam_signal.devise.forbidden_page") %>
                             </div>
                             <div class="login__links">
                                 <%= link_to root_path, class: "button button__sm button__text-secondary" do %>
                                     <%= t("back_home", scope: "decidim.spam_signal.devise.forbidden_page") %>
                                     <%= icon "arrow-right-line", class: "fill-current" %>
                                 <% end %>
                               </div>
                         </div>
                       <% else %>
                         <%= render_original %>
                       <% end %>
                     ERB
                    )

Deface::Override.new(virtual_path: "decidim/shared/_login_modal",
                     name: "authentication_flow_devise_modal",
                     surround_contents: "erb[loud]:contains('decidim_form_for')",
                     closing_selector: "erb[silent]:contains('end')",
                     text: <<~ERB
                       <%
                         if spam_reported?(:hide_authentication) && spam_reported? %>
                           <div data-dialog-container>
                             <%= icon "user-line", class: "w-6 h-6 text-gray fill-current" %>
                             <h3 id="dialog-title-loginModal" class="h3"><%= t("title", scope: "decidim.spam_signal.devise.forbidden_page") %></h3>
                             <div>
                               <%= spam_errors.any? ? spam_errors.messages[:page].join(",") : t("default_message", scope: "decidim.spam_signal.devise.forbidden_page") %>
                               <div data-dialog-actions="">
                                 <button type="button" class="button button__lg button__transparent-secondary" data-dialog-close="loginModal">
                                   <%= t("cancel", scope: "decidim.admin.actions") %>
                                 </button>
                               </div>
                             </div>
                           </div>
                         <% else %>
                           <%= render_original %>
                         <% end %>
                     ERB
                    )
# DESKTOP
############################################################

Deface::Override.new(virtual_path: "layouts/decidim/header/_main_links_desktop",
                     name: "authentication_flow_hide",
                     set_attributes: "div:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     attributes: { class: "<%= spam_reported?(:hide_authentication) && spam_reported? ? 'spam-signal-invalid hidden' : 'spam-signal-valid' %>" })

Deface::Override.new(virtual_path: "layouts/decidim/header/_main_links_desktop",
                     name: "authentication_flow_message",
                     insert_after: "div:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     text: <<~ERB
                       <% if spam_reported?(:hide_authentication) && spam_errors.any? %>
                        <span class="form-error is-visible">
                          <%= spam_errors.messages[:topbar].join(",") %>
                        </span>
                       <% end %>
                     ERB
                    )

# MOBILE
############################################################
Deface::Override.new(virtual_path: "layouts/decidim/header/_main_links_mobile_item_account",
                     name: "authentication_flow_setup_mobile",
                     surround: "erb[loud]:contains('decidim.new_user_session_path')",
                     closing_selector: "erb[silent]:contains('end')",
                     text: <<~ERB
                       <% if spam_reported?(:hide_authentication) && spam_reported? %>
                         <span class="form-error is-visible">
                           <%= spam_errors.messages[:topbar].join(",") %>
                         </span>
                       <% else %>
                         <%= render_original %>
                       <% end %>
                     ERB
                    )

# FOOTER
############################################################
Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_footer_header",
                     set_attributes: "nav:first",
                     attributes: { class: "<%= spam_reported?(:hide_authentication) && spam_reported? ? 'spam-signal-invalid hidden' : 'spam-signal-valid' %>" })

Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_signin",
                     set_attributes: "li:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     attributes: { class: [
                       "font-semibold",
                       "underline",
                       "<%= spam_reported?(:hide_authentication) && spam_reported? ? 'spam-signal-invalid hidden' : 'spam-signal-valid' %>"
                     ].join(" ") })

Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_signup",
                     set_attributes: "li:has(erb[loud]:contains('decidim.new_user_registration_path'))",
                     attributes: {
                       class: [
                         "font-semibold",
                         "underline",
                         "<%= spam_reported?(:hide_authentication) && spam_reported? ? 'spam-signal-invalid hidden' : 'spam-signal-valid' %>"
                       ].join(" ")
                     })
