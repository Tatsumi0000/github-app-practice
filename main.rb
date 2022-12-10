require_relative 'github_app'

if __FILE__ == $0
    github_app = GitHubApp.new('Tatsumi0000/github-app-practice')
    installation_id = github_app.get_installation_id_from_github_api
    access_token = github_app.create_access_token(installation_id)
    github_app.set_access_token(access_token)
    github_app.create_github_release("v3.0.0")
end