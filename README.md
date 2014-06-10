[![Code Climate](https://codeclimate.com/repos/5315eeefe30ba01aa501c119/badges/92e9ca8e93ca2cbc260b/gpa.png)](https://codeclimate.com/repos/5315eeefe30ba01aa501c119/feed)

# ShippingEasy

This is the official wrapper for the ShippingEasy API. 

The ShippingEasy API supports the following features:

* Secure, authenticated intake of orders for shipment
* Cancellation of orders that no longer need to be shipped
* A callback facility that provides shipment information (carrier, cost, tracking number, etc.) for an order
* Query capabilities to read order data from ShippingEasy

We will keep this library up to date as we expand the ShippingEasy API.

## Setup

### Installation

Add this line to your application's Gemfile:

    gem 'shipping_easy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shipping_easy

### Configuration

You will need a ShippingEasy API key and secret to sign your API requests. These can be found in your account's settings (https://app.shippingeasy.com/settings/api_credentials).

Once you have the credentials, add them to the libary's configuration. Do this in an intializer if you're running a Rails app:

    ShippingEasy.configure do |config|
      config.api_key = 'd8e8fca2dc0f896fd7cb4cb0031ba249'
      config.api_secret = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    end


If you are a 3rd party plugin developer and have a staging account with ShippingEasy, you can change the base URL like so:

    config.base_url = 'https://staging.shippingeasy.com'

## Authentication

The ShippingEasy API will hit a callback URL when an order, or a part of an order, has been shipped. The request to the callback URL will be also signed with the same shared secret found in the store's API settings.

This gem provides an Authenticator to handle verifying the signed request from ShippingEasy. Here's an example of how to use it (after you configured the library with your credentials in the step above):

    ShippingEasy::Authenticator.authenticate(method: :post, path: "/callback", body: "{\"shipment\":{\"id\":\"1234\"}}")
    # => true

The arguments for the constructor are as follows:

* **method** - The method of the http request. E.g. "post" or "get".
* **path** - The path of the request's uri. E.g. "/orders/callback"
* **params** - An associative array of the request's query string parameters. E.g. array("api_signature" => "asdsadsad", "api_timestamp" => "1234567899")
* **body** - The request body as a JSON string.
* **api_secret** - Optional. The ShippingEasy API secret for the customer account. Defaults to the global configuration if set.

## API Calls

### Finding an order

To retrieve a specific order, call the find method on the Order resource class.

    ShippingEasy::Resources::Order.find(id: 876)

If successful the call will return a JSON hash with the ShippingEasy order.

Example payload may be found here: 

https://gist.github.com/twmills/491b44fb6e78b20c1266

#### Possible Exceptions

##### ShippingEasy::AccessDeniedError
Your credentials could not be authenticated or the store api_key could not be found.

##### ShippingEasy::ResourceNotFoundError
The requested resource could not be found.

##### ShippingEasy::InvalidRequestError
The order could not be created on the server for one or more of the following reasons:

* The API timestamp could not be parsed.

The exception will contain a message that indicates which of these conditions failed.

### Retrieving multiple orders

To retrieve multiple orders, call the find_all method on the Order resource class with a ShippingEasy order ID specified.

    ShippingEasy::Resources::Order.find_all

If successful the call will return a JSON hash included an array of orders and a hash metadata detailing the conditions used in the search as well as pagination details regarding the response. 

#### Filtering Parameters

**page**
: The page to return in the paginated result set.

**per_page**
: The number of result to include per pagein the paginated result set. Defaults to 50 if not specified and the maximum number of results returned per page is 200.

**last_updated_at**
: Filters the results by the orders' last updated at timestamp and only returns results with a timestamp newer than or equal to the specified value. Defaults to 1 week ago if not specified. The maxiumum time this value can be set to is 3 months ago.

**status**
: Filters the results by the orders' ShippingEasy order status. Defaults to "shipped". Possible values are "shipped" and "ready_for_shipment". It is possible to pass an array of statuses, e.g. ["shipping", "ready_for_shipment"].

**page**
: The page to return in the paginated result set.

**store_api_key**
: By default orders are searched across all the stores on a customer's account. If you would like to filter on a specific API-driven store, include its API key.

#### Filtering Example

    ShippingEasy::Resources::Order.find_all(page: 1, per_page: 1, status: ["ready_for_shipment", "shipped"], last_updated_at: "2014-05-07 14:42:18 UTC")
    
An example JSON response may be found here: 

https://gist.github.com/twmills/005b3c4ab9c85330a801

#### Possible Exceptions

##### ShippingEasy::AccessDeniedError
Your credentials could not be authenticated or the store api_key could not be found.

##### ShippingEasy::InvalidRequestError
The orders could not retrieved for one or more of the following reasons:

* The API timestamp could not be parsed.

The exception will contain a message that indicates which of these conditions failed.

### Adding an order

To add an order to a store, simply call the create method on the Order resource class. (A comprehensive list of the data attributes and their definitions can be found below.)

    payload = { order: "external_order_identifier" => "ABC123", "subtotal_including_tax" => "12.38", ... }
    ShippingEasy::Resources::Order.create(store_api_key: "d8821dde1d32f408def40b77273d5c11", payload: payload)

If successful the call will return a JSON hash with the ShippingEasy order ID, as well as the external order identifier originally supplied in your call.

    { "order" => { "id" => "27654", "external_order_identifier" => "ABC123" } }

#### Possible Exceptions

##### ShippingEasy::AccessDeniedError
Your credentials could not be authenticated or the store api_key could not be found.

##### ShippingEasy::InvalidRequestError
The order could not be created on the server for one or more of the following reasons:

* The JSON payload could not be parsed.
* One or more of the supplied data attributes failed validation and is missing or incorrect.
* An order with the supplied external_order_identifier already exists for that store.

The exception will contain a message that indicates which of these conditions failed.

#### Order Attributes

The following is a list of attributes that should be provided to the ShippingEasy_Order object as a associative array.

An example hash for the create order API call may be found here: https://gist.github.com/twmills/9349053.

**external_order_identifier**
: *Required.* The e-commerce system's order ID.

**ordered_at**
: *Required.* Timestamp when the order was created.

**order_status**
: Possible values are "awaiting_shipment", "awaiting_payment", "awaiting_fulfillment", "awaiting_shipment", "partially_shipped". Default is "awaiting_shipment".

**total_including_tax**
: Defaults to 0.0 if not specified.

**total_excluding_tax**
: Defaults to 0.0 if not specified.

**discount_amount**
: Defaults to 0.0 if not specified.

**coupon_discount**
: Defaults to 0.0 if not specified.

**subtotal_including_tax**
: Defaults to 0.0 if not specified.

**subtotal_excluding_tax**
: Defaults to 0.0 if not specified.

**subtotal_tax**
: Defaults to 0.0 if not specified.

**total_tax**
: Defaults to 0.0 if not specified.

**base_shipping_cost**
: Defaults to 0.0 if not specified.

**shipping_cost_including_tax**
: Defaults to 0.0 if not specified.

**shipping_cost_excluding_tax**
: Defaults to 0.0 if not specified.

**shipping_cost_tax**
: Defaults to 0.0 if not specified.

**base_handling_cost**
: Defaults to 0.0 if not specified.

**handling_cost_excluding_tax**
: Defaults to 0.0 if not specified.

**handling_cost_including_tax**
: Defaults to 0.0 if not specified.

**handling_cost_tax**
: Defaults to 0.0 if not specified.

**base_wrapping_cost**
: Defaults to 0.0 if not specified.

**wrapping_cost_excluding_tax**
: Defaults to 0.0 if not specified.

**wrapping_cost_including_tax**
: Defaults to 0.0 if not specified.

**wrapping_cost_tax**
: Defaults to 0.0 if not specified.

**notes**
: Customer notes on the order.

**billing_company**
: Company name for billing address

**billing_first_name**
: Customer first name for billing address

**billing_last_name**
: Customer last name for billing address

**billing_address**
: First address line for billing address

**billing_address2**
: Additional address line for billing address

**billing_city**
: City name for billing address

**billing_state**
: State name for billing address

**billing_country**
: Country name for billing address

**billing_postal_code**
: Postal code for billing address

**billing_phone_number**
: Phone number.

**billing_email**
: Email address

**recipients**
: A nested associative array of recipient attributes. At least one recipient is required.

**recipients > company**
: Company name for shipping address

**recipients > first_name**
: Customer first name for shipping address

**recipients > last_name**
: Customer last name for shipping address

**recipients > address**
: *Required.* First address line for shipping address

**recipients > address2**
: Additional address line for shipping address

**recipients > city**
: City name for shipping address

**recipients > state**
: State name for shipping address

**recipients > country**
: Country name for shipping address

**recipients > residential**
: Whether or not address is residential or not. Value can be "true" or "false".

**recipients > postal_code**
: *Required.* Postal code for shipping address

**recipients > postal_code_plus_4**
: Postal code plus 4 for shipping address

**recipients > phone_number**
: Customer phone number

**recipients > email**
: Customer email address

**recipients > base_cost**
: Cost before tax for all line items sent to this recipient

**recipients > cost_excluding_tax**
: Cost before tax for all line items sent to this recipient

**recipients > cost_including_tax**
: Cost including tax for all line items sent to this recipient

**recipients > cost_tax**
: Cost of the tax for all line items sent to this recipient

**recipients > base_handling_cost**
: Handling cost before tax for all line items sent to this recipient

**recipients > handling_cost_excluding_tax**
: Handling cost before tax for all line items sent to this recipient

**recipients > handling_cost_including_tax**
: Handling cost including tax for all line items sent to this recipient

**recipients > handling_cost_tax**
: Handling cost of the tax for all line items sent to this recipient

**recipients > shipping_zone_id**
: ID of the shipping zone.

**recipients > shipping_zone_name**
: Name of the shipping zone.

**recipients > shipping_method**
: Method of shipment.

**recipients > items_total**
: Total number of items.

**recipients > items_shipped**
: Total number of items shipped.

**recipients > line_items**
: A nested associative array of line item attributes. At least one line item is required.

**recipients > line_items > item_name**
: Name of the item/product.

**recipients > line_items > sku**
: SKU of the item/product.

**recipients > line_items > bin_picking_number**
: Bin number where the item may be stored in a warehouse.

**recipients > line_items > weight_in_ounces**
: Weight of the line item in ounces.

**recipients > line_items > quantity**
: Quantity of the the items for the line item.

**recipients > line_items > total_excluding_tax**
: Total excluding tax for the line item.

**recipients > line_items > unit_price**
: Unit price of the item.

**recipients > line_items > product_options**
: Hash of product variations applicable to this line item. E.g. {"color":"red", "size":"XXL"}

### Cancelling an order

Sometimes an e-commerce system will mark an order as shipped outside of the ShippingEasy system. Therefore an API call is required to remove this order from ShippingEasy so that it is not double-shipped.

Here's an example using your store's API key and the e-commerce order identifier used to create the order in ShippingEasy:

    ShippingEasy::Resources::Cancellation.create(store_api_key: "d8821dde1d32f408def40b77273d5c11", external_order_identifier: "ABC123")

If successful the call will return a JSON hash with the ShippingEasy order ID, as well as the external order identifier originally supplied in your call.

    { "order" => { "id" => "27654", "external_order_identifier" => "ABC123" } }

#### Possible Exceptions

##### ShippingEasy::AccessDeniedError
Your credentials could not be authenticated or the store api_key could not be found.

##### ShippingEasy::InvalidRequestError
The cancellation could not complete for one or more of the following reasons:

* The order could not be found.
* The order has already been marked as shipped in the ShippingEasy system and cannot be cancelled.

The exception will contain a message that indicates which of these conditions failed.

## Making requests via curl
First you will need to create an API signature. Concatenate these into a plaintext string using the following order:

1. Capitilized method of the request. E.g. "POST"
2. The URI path
3. The query parameters sorted alphabetically and concatenated together into a URL friendly format: param1=ABC&param2=XYZ
4. The request body as a string if one exists

All parts are then concatenated together with an ampersand. The result resembles something like this:

    "POST&/api/orders&api_key=f9a7c8ebdfd34beaf260d9b0296c7059&api_timestamp=1401803554&{\"orders\":{\"name\":\"Flip flops\",\"cost\":\"10.00\",\"shipping_cost\":\"2.00\"}}"

Finally, using your API secret encrypt the string using HMAC sha256. In ruby, it looks like this:

    OpenSSL::HMAC::hexdigest("sha256", api_secret, "POST&/api/orders&api_key=f9a7c8ebdfd34beaf260d9b0296c7059&api_timestamp=1401803554&{\"orders\":{\"name\":\"Flip flops\",\"cost\":\"10.00\",\"shipping_cost\":\"2.00\"}}")

### API timestamp
You must include an API timestamp in your requests. The timestamp should be an integer representation of the current time.

### Example curl request

````shell
curl -H "Content-Type: application/json" --data @body.json "https://app.shippingeasy.com/api/stores/27aa472e16faa83dd13b7758d31974ed/orders?api_key=f9a7c8ebdfd34beaf260d9b0296c7059&api_timestamp=1401803554&api_signature=c65f43beed46e581939898a78acd10064cfa146845e97885ec02124d7ad648e4"
````

An example body.json can be found here:

https://gist.github.com/twmills/3f4636b835c611ab3f7f


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
