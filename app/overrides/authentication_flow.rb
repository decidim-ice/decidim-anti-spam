# frozen_string_literal: true

# DEVISE SCREENS
############################################################

Deface::Override.new(virtual_path: "layouts/decidim/shared/_layout_center",
                     name: "authentication_flow_devise",
                     surround_contents: "erb[loud]:contains('main_tag')",
                     closing_selector: "erb[silent]:contains('end')",
                     text: <<~ERB
                       <%
                        antispam_authentication_flow = Decidim::SpamSignal::AuthenticationValidationForm.new.with_context(
                            current_organization: current_organization
                         )
                         antispam_authentication_flow.validate
                        %>
                        <% if antispam_authentication_flow.errors.empty? %>
                          <%= render_original %>
                        <% else %>
                        <div>
                            <h1 class="title-decorator my-12"><%= t("title", scope: "decidim.spam_signal.devise.forbidden_page") %></h1>
                            <div class="login__info font-semibold">
                              <%= antispam_authentication_flow.errors.full_messages.join(', ') || t("default_message", scope: "decidim.spam_signal.devise.forbidden_page") %>
                            </div>
                            <div class="login__links">
                                <%= link_to root_path, class: "button button__sm button__text-secondary" do %>
                                    <%= t("back_home", scope: "decidim.spam_signal.devise.forbidden_page") %>
                                    <%= icon "arrow-right-line", class: "fill-current" %>
                                <% end %>
                              </div>
                        </div>
                        <% end %>
                     ERB
                    )

Deface::Override.new(virtual_path: "decidim/shared/_login_modal",
                     name: "authentication_flow_devise_modal",
                     surround_contents: "erb[loud]:contains('decidim_form_for')",
                     closing_selector: "erb[silent]:contains('end')",
                     text: <<~ERB
                       <%
                         antispam_authentication_flow = Decidim::SpamSignal::AuthenticationValidationForm.new.with_context(
                            current_organization: current_organization
                         )
                         antispam_authentication_flow.validate

                         if antispam_authentication_flow.errors.any? %>
                           <div data-dialog-container>
                             <%= icon "user-line", class: "w-6 h-6 text-gray fill-current" %>
                             <h3 id="dialog-title-loginModal" class="h3"><%= t("title", scope: "decidim.spam_signal.devise.forbidden_page") %></h3>
                             <%= antispam_authentication_flow.errors.full_messages.join(', ') || t("default_message", scope: "decidim.spam_signal.devise.forbidden_page") %>
                             <div>
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
                     name: "authentication_flow_setup",
                     insert_before: "div:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     text: <<~ERB
                       <%#{" "}
                        antispam_authentication_flow = Decidim::SpamSignal::AuthenticationValidationForm.new.with_context(
                            current_organization: current_organization
                         )
                         antispam_authentication_flow.validate
                        %>
                     ERB
                    )

Deface::Override.new(virtual_path: "layouts/decidim/header/_main_links_desktop",
                     name: "authentication_flow_hide",
                     set_attributes: "div:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     attributes: { class: "<%= antispam_authentication_flow.errors.empty? ? 'spam-signal-valid' : 'spam-signal-invalid hidden' %>" })

Deface::Override.new(virtual_path: "layouts/decidim/header/_main_links_desktop",
                     name: "authentication_flow_message",
                     insert_after: "div:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     text: <<~ERB
                       <span class="form-error is-visible"><%= antispam_authentication_flow.errors.empty? ? '' : antispam_authentication_flow.errors.full_messages.join(', ') %></span>
                     ERB
                    )

# MOBILE
############################################################
Deface::Override.new(virtual_path: "layouts/decidim/header/_main_links_mobile_item_account",
                     name: "authentication_flow_setup_mobile",
                     surround: "erb[loud]:contains('decidim.new_user_session_path')",
                     closing_selector: "erb[silent]:contains('end')",
                     text: <<~ERB
                       <%#{" "}
                        antispam_authentication_flow = Decidim::SpamSignal::AuthenticationValidationForm.new.with_context(
                            current_organization: current_organization
                         )
                         antispam_authentication_flow.validate
                        %>
                        <% if antispam_authentication_flow.errors.empty? %>
                          <%= render_original %>
                        <% else %>
                          <span class="form-error is-visible"><%= antispam_authentication_flow.errors.full_messages.join(', ') %></span>
                        <% end %>
                     ERB
                    )

# FOOTER
############################################################
Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_setup",
                     insert_after: "erb[loud]:contains('footer_menu.render')",
                     text: <<~ERB
                       <%
                        antispam_authentication_flow = Decidim::SpamSignal::AuthenticationValidationForm.new.with_context(
                            current_organization: current_organization
                         )
                         antispam_authentication_flow.validate
                        %>
                     ERB
                    )

Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_signin",
                     set_attributes: "li:has(erb[loud]:contains('decidim.new_user_session_path'))",
                     attributes: { class: "<%= antispam_authentication_flow.errors.empty? ? 'spam-signal-valid' : 'spam-signal-invalid hidden' %>" })

Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_footer_header",
                     set_attributes: "nav:first",
                     attributes: { class: "<%= antispam_authentication_flow.errors.empty? ? 'spam-signal-valid' : 'spam-signal-invalid hidden' %>" })

Deface::Override.new(virtual_path: "layouts/decidim/footer/_main_links",
                     name: "authentication_flow_footer_signup",
                     set_attributes: "li:has(erb[loud]:contains('decidim.new_user_registration_path'))",
                     attributes: { class: "<%= antispam_authentication_flow.errors.empty? ? 'spam-signal-valid' : 'spam-signal-invalid hidden' %>" })
