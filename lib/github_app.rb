require 'openssl'
require 'jwt'

module GithubApp
  def self.jwt_token(pem_path: './github-app.pem', app_id: 44519)
    private_pem = File.read(pem_path)
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

  def self.get_token(jwt: jwt_token, installation_id: 6883212)
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
