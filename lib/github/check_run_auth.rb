# frozen_string_literal: true

require 'openssl'
require 'jwt'
require 'base64'

module Github
  module CheckRunAuth
    def self.github_token(private_pem:, app_id:, installation_id:)
      fetch_token(
        jwt: jwt_token(private_pem: private_pem, app_id: app_id),
        installation_id: installation_id
      )
    end

    def self.jwt_token(private_pem:, app_id:)
      private_key = OpenSSL::PKey::RSA.new(private_pem)

      payload = {
        # issued at time
        iat: Time.now.to_i,
        # JWT expiration time (10 minute maximum)
        exp: Time.now.to_i + (10 * 60),
        # GitHub App's identifier
        iss: app_id
      }

      JWT.encode(payload, private_key, 'RS256')
    end

    def self.fetch_token(jwt:, installation_id:)
      url = URI("https://api.github.com/app/installations/#{installation_id}/access_tokens")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request['authorization'] = "Bearer #{jwt}"
      request['accept'] = 'application/vnd.github.machine-man-preview+json'
      response = http.request(request)

      JSON.parse(response.read_body)['token']
    end
  end
end
