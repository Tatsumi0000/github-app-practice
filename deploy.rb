require 'octokit'

def deploy_to_github_releases
    client = Octokit::Client.new(bearer_token: ENV['TOKEN'])
    client.create_release(ENV['GITHUB_REPOSITORY'], ENV['SHA'])
end

if __FILE__ == $0
    deploy_to_github_releases
end