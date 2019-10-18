module RspecExtensions
  module APIHelpers
    #
    # Request
    #

    def headers
      @headers ||= {}
    end

    def set_ssl
      # there are four ways in which Rack tests for SSL
      # setting all of them by way of documenting this.
      headers['HTTPS']                  = 'on'
      headers['HTTP_X_FORWARDED_SSL']   = 'on'
      headers['HTTP_X_FORWARDED_PROTO'] = 'https'
      headers['rack.url_scheme']        = 'https'
    end

    def api(method, path, params = {})
      set_ssl
      headers['Accept'] = 'application/json'
      method = :make_post if method == :post
      send(method, '/api/v1' + path, params, headers)
    end

    #
    # JSON Response
    #

    def json_response
      json = {}
      expect do
        json = JSON.parse(response.body, json_response_parse_options)
      end.not_to raise_error
      json
    end

    def json_response_parse_options
      { symbolize_names: false }
    end

    # json_key('entries[0].post.id')
    def json_query(keys = [], json = nil)
      json ||= json_response
      keys = keys.to_s.split('.') unless keys.is_a?(Array)

      keys.each do |seg|
        key, hash_key, is_array, array_index = seg.match(/([a-z_0-9]*)(\[([\-\d]*)\]){0,1}/).to_a
        # puts [json, seg, key, hash_key, is_array, array_index].inspect
        raise "#{keys.join('.')}: #{key} not found" unless json
        begin
          hash_key = hash_key.to_sym if json_response_parse_options[:symbolize_names]

          json = json[hash_key]
          json = json[array_index.to_i] if is_array
        rescue => e
          raise [json, hash_key, array_index].inspect
        end
      end

      json
    end

    def pretty_response_body
      return '' if response.body.empty?

      JSON.pretty_generate JSON.parse(response.body)
    end

    #
    # Expect
    #

    def expect_json(keys = [])
      expect json_query(keys)
    end

    # &todo covert to expect_api.to have_responses(hash) format
    def expect_api(hash = {})
      expect([200, 201]).to include(response.status)
      hash.each do |key, value|
        value = value.utc.to_json.delete('"') if value.is_a?(Time) || value.is_a?(DateTime)
        matcher = eq(value) unless value.inspect =~ /RSpec::Matchers/
        expect_json(key).to matcher
      end
      expect(json_response)
    end

    def expect_api_delete
      expect(response.status).to eq(204)
      expect(response.body).to be_blank
    end

    def expect_api_error(code = 400)
      expect(response.status).to eql(code)
      expect(json_response['error'] || json_response['errors'])
    end

    # JSON:API
    def expect_json_pagination(options = {}, &block)
      expect_api.to match a_hash_including(
        'entries' => (block ? block.call : be_an(Array)),
        'total_entries' => options[:total_entries] || be_a(Integer),
        'page' => options[:page] || be_a(Integer)
      )
    end
  end
end