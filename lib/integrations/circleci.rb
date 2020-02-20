# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require_relative '../rubocop_linter_app'

token = GithubCheckRunAuth.github_token(
  private_pem: Base64.decode64(ENV['PEM_KEY']),
  app_id: ENV['GITHUB_APP_ID'],
  installation_id: ENV['GITHUB_APP_INSTALLATION_ID']
)

@github_data = {
  sha: ENV['CIRCLE_SHA1'],
  token: token,
  owner: ENV['CIRCLE_PROJECT_USERNAME'],
  repo: ENV['CIRCLE_PROJECT_REPONAME']
}

RubocopLinterApp.run(github_data: @github_data, report_path: ENV['REPORT_PATH'])
