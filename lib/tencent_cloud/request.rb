# frozen_string_literal: true

require 'erb'

module TencentCloud
  module Request
    def get_federation_token
      payload = {
        service: 'sts',
        headers: {
          'host' => 'sts.tencentcloudapi.com',
          'X-TC-Action' => 'GetFederationToken',
          'X-TC-Version' => '2018-08-13'
        },
        'Name' => 'smb',
        'Policy' => ERB::Util.url_encode({
          "version": "2.0",
          "statement": [
            {
              "action": [
                "name/cos:*"
              ],
              "resource": "*",
              "effect": "allow"
            },
            {
              "effect": "allow",
              "action": "monitor:*",
              "resource": "*"
            }
          ]
        }.to_json)
      }
      endpoint = "https://#{payload.dig(:headers, 'host')}"
      make_get(endpoint, payload)
    end
  end
end
