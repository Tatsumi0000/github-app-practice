require 'jwt'
require 'octokit'

# JWT TOKENを生成する
def create_jwt_token
    # Private key contents
    private_pem = File.read("./XXX.pem")
    private_key = OpenSSL::PKey::RSA.new(private_pem)
      
    # Generate the JWT
    payload = {
      # issued at time, 60 seconds in the past to allow for clock drift
      iat: Time.now.to_i - 60,
      # JWT expiration time (10 minute maximum)
      exp: Time.now.to_i + (10 * 60),
      # GitHub App's identifier
      # https://git.pepabo.com/organizations/colorme/settings/apps/colorme-token-app
      iss: "YYY"
    }
      
    jwt = JWT.encode(payload, private_key, "RS256")
    return jwt
end

# 
def reuquest_github_app_info
    client = Octokit::Client.new(bearer_token: create_jwt_token)
    p client.app
end