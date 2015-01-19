# OmniAuth PayPal Permissions

**Note:** This gem is designed to work with OmniAuth 1.0 library.

This gem contains the PayPal permissions service strategy for OmniAuth.

## Installing

Add to your `Gemfile`:

```ruby
gem "omniauth-paypal-permissions"
```

Then `bundle install`.

## Usage

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :paypal_permissions, {
      :mode      => "sandbox",  # Set "live" for production
      :app_id    => "APP-80W284485P519543T",
      :username  => "jb-us-seller_api1.paypal.com",
      :password  => "WX4WTU3S8MY44S7F",
      :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31A7yDhhsPUU2XhtMoZXsWHFxu-RWy"
    }, scope: ["ACCESS_BASIC_PERSONAL_DATA","TRANSACTION_SEARCH"]
end
```

## Attributes and Scopes

PayPal permissions service information can be found on https://developer.paypal.com/docs/classic/permissions-service/ht_permissions-invoice/

The possible attributes to be returned at the moment are:

```ruby
info['display_name']
info['email']
info['first_name']
info['last_name']
info['full_name']
info['company_name']
```

The "ACCESS_BASIC_PERSONAL_DATA" scope *must* be set for this to work.

## Using Credentials

Within the OmniAuth auth hash, `token` and `token_secret` are set within the credentials hash. For example, in the callback, you could use this to fetch the user's information:

```ruby
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def paypalpermissions
    @credentials = env["omniauth.auth"].credentials
    @paypal_config = {
      :mode      => "sandbox",  # Set "live" for production
      :app_id    => "APP-80W284485P519543T",
      :username  => "jb-us-seller_api1.paypal.com",
      :password  => "WX4WTU3S8MY44S7F",
      :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31A7yDhhsPUU2XhtMoZXsWHFxu-RWy"
    }
    @api = ::PayPal::SDK::Permissions::API.new(@paypal_config.merge({
      :token => @credentials.token,
      :token_secret => @credentials.token_secret
    }))
    response = @api.get_basic_personal_data({
        :attributeList => {
          :attribute => [ "http://axschema.org/namePerson/first",
                          "http://axschema.org/namePerson/last",
                          "http://schema.openid.net/contact/fullname",
                          "http://axschema.org/company/name",
                          "http://axschema.org/contact/email",
                          "https://www.paypal.com/webapps/auth/schema/payerID" ] } })
    if response.success?
      # YAY! User data!
    else
      # BOO :(
    end
  end
end
```

## License

This code is open-sourced under the Apache License, a copy of which is available in the LICENSE file.
