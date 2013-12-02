require 'httparty'
module Callink
  module Organization
      extend self
      @@base_url="https://api.berkeley.edu/callink/CalLinkOrganizations" # https://apis-dev.berkeley.edu/callink/CalLinkOrganizations
      def search(params = {})
        HTTParty.get(search_url(params))
      end
      private
      def search_url(params = {})
        # https://wikihub.berkeley.edu/pages/viewpage.action?pageId=80479487
        qs = URI.escape(default_params.merge(params).collect{|k,v| "#{k}=#{v}"}.join('&'))
        "#{@@base_url}?#{qs}"
      end
      def default_params
        {
            name: nil,
            type: nil,
            category: nil,
            status: nil,
            excludeHiddenOrganizations: nil,
            organizationId: nil,
            app_id: ENV['CALLINK_API_KEY'],
            app_key: ENV['CALLINK_APP_ID'],
        }
      end
  end
end
