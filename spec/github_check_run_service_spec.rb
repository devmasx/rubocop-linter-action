# frozen_string_literal: true

require './spec/spec_helper'

describe GithubCheckRunService do
  let(:brakeman_report) { JSON(File.read('./spec/fixtures/report.json')) }
  let(:github_data) { { sha: 'sha', token: 'token', owner: 'owner', repo: 'repository_name' } }
  let(:service) { GithubCheckRunService.new(brakeman_report, github_data, ReportAdapter) }

  it '#run' do
    stub_request(:any, 'https://api.github.com/repos/owner/repository_name/check-runs/id')
      .to_return(status: 200, body: '{}')

    stub_request(:any, 'https://api.github.com/repos/owner/repository_name/check-runs')
      .to_return(status: 200, body: '{"id": "id"}')

    output = service.run
    expect(output).to be_a(Hash)
  end

  context 'annotation limit set' do
    it 'updates the check run multiple times' do
      stub_request(:any, 'https://api.github.com/repos/owner/repository_name/check-runs')
        .to_return(status: 200, body: '{"id": "id"}')

      stub_const("GithubCheckRunService::MAX_ANNOTATIONS_SIZE", 2)
      allow(service).to receive(:client_patch).and_return({})
      expect(service).to receive(:client_patch).twice
      service.run
    end
  end
end