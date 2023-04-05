require 'singleton'

module Decidim
  class Akismet
    include Singleton
    # Check if the Akismet API is ready for use
    #
    # @return [Boolean] true if the API key and site URL are present and valid, false otherwise
    def ready?
      api_key = ENV.fetch("AKISMET_API_KEY", "").present?
      site_url = ENV.fetch("AKISMET_SITE_URL", "").present?
      return false unless api_key && site_url
      query("/1.1/verify-key", { key: ENV.fetch("AKISMET_API_KEY"), blog: ENV.fetch("AKISMET_SITE_URL") }).body == "valid"
    end

    ##
    # Run akismet and return one of the three symbols:
    # 1. :ham this is nothing
    # 2. :suspicious this looks wired
    # 3. :spam this is a spam for sure, you can safely discard it, its user etc.
    def detect!(
      comment_type:,
      current_organization:,
      user:,
      user_ip:,
      user_agent:,
      referrer:,
      permalink:,
      content:,
      date:,
      is_updating:)
      return :ham if user_ip.nil? || user_ip.empty?
      valid_comment_type = [
        :comment,
        :"forum-post",
        :reply,
        :"blog-post",
        :"contact-form",
        :signup,
        :message
      ]
      raise "#{comment_type} is not a valid comment type" unless valid_comment_type.include? "#{comment_type}".to_sym
      payload = {
        "api_key": ENV.fetch("AKISMET_API_KEY"),
        "blog": ENV.fetch("AKISMET_SITE_URL"),
        "user_ip": user_ip,
        "user_agent": user_agent,
        "comment_type": comment_type,
        "blog_charset": "UTF-8"
      }
      payload["referrer"] = referrer if referrer
      if user
        payload["comment_author"] = user.name
        payload["comment_author_email"] = user.email
        payload["comment_author_url"] = user.email
      end
      if is_updating
        payload["recheck_reason"] = "edit"
        payload["comment_post_modified_gmt"] = date.iso8601 if date
      else
        payload["comment_date_gmt"] = date.iso8601 if date
      end
      payload["blog_lang"] = current_organization.available_locales.map { |l| l.downcase.sub(/-/, "_") }.join(",") if current_organization
      payload["user_role"] = "administrator" if user && user.admin

      response = query("/1.1/comment-check", payload)
      if response.header["X-akismet-pro-tip"]
        return :spam
      end
      response.body == "true" ? :suspicious : :ham
    end



    private
      # Public: This method is used to send a query to the Akismet API.
      #
      # path - A String representing the endpoint of the API to send the query to.
      # payload - A Hash containing the parameters to be sent in the query.
      #
      # Examples
      #
      #   query("/1.1/comment-check", { blog: "https://example.com", user_ip: "127.0.0.1", comment_content: "This is a spam comment." })
      #   # => #<Net::HTTPOK 200 OK readbody=true>
      #
      # Returns a Net::HTTPResponse object containing the response from the API.
      def query(path, payload)
        http = Net::HTTP.new("rest.akismet.com")
        http.post(
          path,
          payload.to_query,
          {
            "User-Agent": "WordPress/4.4.1 | Akismet/3.1.7"
          }
        )
      end
  end
end
