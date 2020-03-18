# frozen_string_literal: true

require 'net/http'
require 'json'
require 'time'
require_relative "./report_adapter"
require_relative "./github_check_run_service"
require_relative "./github_client"
require_relative "./github_app"

module RobocopLinterApp
  def self.run(github_data: nil, report_path: nil)
    report =
      if report_path
        read_json(report_path)
      else
        JSON.parse(`rubocop -f json`)
      end

    GithubCheckRunService.new(report, github_data, ReportAdapter).run
  end

  def self.read_json(path)
    JSON.parse(File.read(path))
  end
end
