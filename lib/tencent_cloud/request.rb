# frozen_string_literal: true

require 'erb'

module TencentCloud
  module Request
    def get_federation_token
      policy = {
        "version": "2.0",
        "statement": [
          {
            "action": [
              "name/cos:GetObject",
              # 简单上传
              "name/cos:PutObject",
              # 表单上传、小程序上传
              "name/cos:PostObject",
              # 分块上传
              "name/cos:InitiateMultipartUpload",
              "name/cos:ListMultipartUploads",
              "name/cos:ListParts",
              "name/cos:UploadPart",
              "name/cos:CompleteMultipartUpload"
            ],
            "resource": "qcs::cos:#{config.region}:uid/#{config.bucket.split('-').last}:#{config.bucket}/*",
            "effect": "allow"
          }
        ]
      }.to_json
      payload = {
        service: 'sts',
        headers: {
          'host' => 'sts.tencentcloudapi.com',
          'X-TC-Action' => 'GetFederationToken',
          'X-TC-Version' => '2018-08-13'
        },
        'Name' => 'smb',
        'Policy' => ERB::Util.url_encode(policy)
      }
      endpoint = "https://#{payload.dig(:headers, 'host')}"
      make_get(endpoint, payload)
    end
  end
end
