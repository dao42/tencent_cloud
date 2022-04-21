# frozen_string_literal: true

require 'json'
require 'digest'
require 'openssl'
require 'uri'

module TencentCloud
  module Client
    extend Request
    extend Response

    class << self
      def config
        TencentCloud::Configuration.instance
      end

      private

      def make_post(api_url, data)
        method = :post
        headers = make_headers(method, data)
        resp = send_request(
          method,
          api_url,
          headers: headers,
          json: data
        )
        parse_response(resp)
      end

      def make_get(api_url, data)
        method = :get
        headers = make_headers(method, data)
        url =
          if data.present?
            "#{api_url}?#{URI.encode_www_form(data)}"
          else
            api_url
          end
        resp = send_request(
          method,
          url,
          headers: headers
        )
        parse_response(resp)
      end

      def make_headers(method, data = nil)
        headers = {
          'content-type' => content_type(method),
          'X-TC-Timestamp' => Time.now.to_i,
          'X-TC-Region' => config.region
        }
        headers.merge!(data.delete(:headers)) if data && data[:headers].present?
        headers['Authorization'] = make_sign(method, headers, data)
        headers
      end

      CANONICAL_URI = '/'

      def make_sign(method, headers, payload)
        service = payload.delete(:service)
        canonical_query, hash_request_payload = if method.to_s.downcase.eql?('get') && payload.present?
                                                  [URI.encode_www_form(payload), Digest::SHA2.hexdigest('')]
                                                else
                                                  [Digest::SHA2.hexdigest(''), Digest::SHA2.hexdigest(payload.to_json)]
                                                end
        sign_headers = %w(content-type host).sort
        canonical_headers = sign_headers.map { |h| "#{h}:#{headers[h]}\n" }.join
        signed_headers = sign_headers.join(';')
        canonical_request = [
          method.upcase, CANONICAL_URI, canonical_query, canonical_headers, signed_headers, hash_request_payload
        ].join("\n")

        algorithm = 'TC3-HMAC-SHA256'
        request_timestamp = headers['X-TC-Timestamp']
        date = Time.at(request_timestamp).utc.strftime('%Y-%m-%d')
        credential_scope = date + '/' + service + '/' + 'tc3_request'
        hash_canonical_request = Digest::SHA2.hexdigest(canonical_request)
        str_to_sign = [
          algorithm, request_timestamp.to_s, credential_scope, hash_canonical_request
        ].join("\n")

        digest = OpenSSL::Digest.new('sha256')
        secret_date = OpenSSL::HMAC.digest(digest, 'TC3' + config.secret_key.to_s, date)
        secret_service = OpenSSL::HMAC.digest(digest, secret_date, service)
        secret_signing = OpenSSL::HMAC.digest(digest, secret_service, 'tc3_request')
        signature = OpenSSL::HMAC.hexdigest(digest, secret_signing, str_to_sign)
        "#{algorithm} Credential=#{config.secret_id}/#{credential_scope}, SignedHeaders=#{signed_headers}, Signature=#{signature}"
      end

      def send_request(method, url, **data)
        HTTP.request(
          method,
          url,
          **data
        )
      end

      def content_type(method)
        if method.to_s.eql?('get')
          'application/x-www-form-urlencoded; charset=utf-8'
        else
          'application/json; charset=utf-8'
        end
      end
    end
  end
end
