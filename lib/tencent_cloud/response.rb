# frozen_string_literal: true

module TencentCloud
  module Response
    def parse_response(resp)
      if resp.code == 200
        [resp.parse, nil]
      else
        [nil, resp.body.to_s]
      end
    end
  end
end
