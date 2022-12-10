require 'jwt'
require 'octokit'

class GitHubApiRequest

  def initialize(repository_name)
    @client = Octokit::Client.new
    @repository_name = repository_name
    create_jwt_token
  end

  # JWT TOKENを生成する
  def create_jwt_token
    # ダウンロードした秘密鍵
    private_pem = File.read("./XXX.pem")
    private_key = OpenSSL::PKey::RSA.new(private_pem)
      
    # Generate the JWT
    payload = {
      # issued at time, 60 seconds in the past to allow for clock drift
      iat: Time.now.to_i - 60,
      # JWT expiration time (10 minute maximum)
      exp: Time.now.to_i + (10 * 60),
      # 今回作成したGitHub AppのID
      # https://git.pepabo.com/organizations/colorme/settings/apps/colorme-token-app
      iss: "YYY"
    }
      
    jwt = JWT.encode(payload, private_key, "RS256")
    @client.bearer_token = jwt
  end

  private :create_jwt_token

  # installation_idを取得
  def get_installation_id_from_github_api
    installation_id = @client.find_repository_installation(@repository_name).id
    return installation_id
  end

  # アクセストークンを生成
  def create_access_token(installation_id)
    access_token = @client.create_app_installation_access_token(installation_id).token
    return access_token
  end

  # アクセストークンを生成
  def set_access_token(access_token)
    @client.bearer_token = access_token
  end

  # GitHub Releasesを作成
  def create_github_release(tag_name)
    @client.create_release(@repository_name, tag_name)
  end

end
