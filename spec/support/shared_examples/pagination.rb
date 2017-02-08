shared_examples 'paginated list' do
  it { expect(json_response[:meta][:pagination]).to be_truthy }
  it { expect(json_response[:meta][:pagination][:'current-page']).to be_truthy }
  it { expect(json_response[:meta][:pagination][:'next-page']).to be_truthy }
  it { expect(json_response[:meta][:pagination][:'total-pages']).to be_truthy }
  it { expect(json_response[:meta][:pagination][:'total-count']).to be_truthy }
end
