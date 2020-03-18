# frozen_string_literal: true

require_relative './robocop_linter_app'

@github_data = {
  sha: ENV['CIRCLE_SHA1'],
  token: GithubApp.get_token,
  owner: ENV['CIRCLE_PROJECT_USERNAME'],
  repo: ENV['CIRCLE_PROJECT_REPONAME']
}

RobocopLinterApp.run(github_data: @github_data, report_path: ENV['REPORT_PATH'])
