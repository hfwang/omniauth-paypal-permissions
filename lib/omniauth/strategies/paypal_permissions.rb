require "omniauth"
require "paypal-sdk-permissions"

module OmniAuth
  module Strategies
    class PaypalPermissions
      include OmniAuth::Strategy

      args [:sdk_config]

      option :sdk_config, {}
      option :scope, ["ACCESS_BASIC_PERSONAL_DATA"]

      uid do
        raw_info["uid"]
      end

      info do
        raw_info
      end
      credentials do
        {
          :token => access_token.config.token,
          :token_secret => access_token.config.token_secret
        }
      end

      extra do
        {
          :raw_info => raw_info
        }
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def setup_phase
        @api = ::PayPal::SDK::Permissions::API.new(options.sdk_config.to_h)
        super
      end

      def request_phase
        @request_permissions = @api.build_request_permissions({
            :scope => options.scope,
            :callback => callback_url })
        @response = @api.request_permissions(@request_permissions)

        if @response.success?
          @response.token
          redirect @api.grant_permission_url(@response) # Redirect url to grant permissions
        else
          raise "Error: " + @response.error.inspect
          fail(:invalid_credentials)
        end
      end

      def raw_info
        @raw_info ||= load_identity()
        @raw_info
      end

      private
      def access_token
        if !@access_token
          get_access_token = @api.build_get_access_token({
            :token => request.params["request_token"],
            :verifier => request.params["verification_code"]
          })

          get_access_token_response = @api.get_access_token(get_access_token)
          @access_token = ::PayPal::SDK::Permissions::API.new(options.sdk_config.to_h.merge({
              :token => get_access_token_response.token,
              :token_secret => get_access_token_response.tokenSecret }))

        end
        return @access_token
      end

      def load_identity
        response = access_token.get_basic_personal_data({
            :attributeList => {
              :attribute => [ "http://axschema.org/namePerson/first",
                              "http://axschema.org/namePerson/last",
                              "http://schema.openid.net/contact/fullname",
                              "http://axschema.org/company/name",
                              "http://axschema.org/contact/email",
                              "https://www.paypal.com/webapps/auth/schema/payerID" ] } })
        if response.success?
          identity = {}
          response.response.personalData.each do |datum|
            key = case datum.personalDataKey
                  when "https://www.paypal.com/webapps/auth/schema/payerID"
                    "uid"
                  when "http://axschema.org/namePerson/first"
                    "first_name"
                  when "http://axschema.org/namePerson/last"
                    "last_name"
                  when "http://axschema.org/contact/email"
                    "email"
                  when "http://schema.openid.net/contact/fullname"
                    "full_name"
                  when "http://axschema.org/company/name"
                    "company_name"
                  else
                    nil
                  end
            identity[key] = datum.personalDataValue
          end
          identity["display_name"] = identity["company_name"] || identity["full_name"]
          identity
        else
          fail!(:invalid_credentials, response.error.first)
        end
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
    end
  end
end
OmniAuth.config.add_camelization 'paypal_permissions', 'PaypalPermissions'
OmniAuth.config.add_camelization 'paypalpermissions', 'PaypalPermissions'
