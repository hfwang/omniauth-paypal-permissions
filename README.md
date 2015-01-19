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

The actual set of attributes returned depends on the scopes set. The currently available scopes are listed under the Permission Groups header on https://developer.paypal.com/docs/classic/permissions-service/integration-guide/PermissionsAbout/

## License

This code is open-sourced under the Apache License, a copy of which is available in the LICENSE file.
