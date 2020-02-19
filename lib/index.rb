# frozen_string_literal: true

require 'net/http'
require 'json'
require 'time'
require_relative "./report_adapter"
require_relative "./github_check_run_service"
require_relative "./github_client"

def read_json(path)
  JSON.parse(File.read(path))
end

@github_data = {
  sha: ENV['CIRCLE_SHA1'],
  token: ENV['GITHUB_TOKEN'],
  owner: ENV['CIRCLE_PROJECT_USERNAME'],
  repo: ENV['CIRCLE_PROJECT_REPONAME']
}

@report =
  if ENV['REPORT_PATH']
    read_json(ENV['REPORT_PATH'])
  else
    Dir.chdir(ENV['CIRCLE_WORKING_DIRECTORY']) { JSON.parse(`brakeman -f json`) }
  end

GithubCheckRunService.new(@report, @github_data, ReportAdapter).run
