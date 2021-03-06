require 'spec_helper'

RSpec.describe 'Record Email', type: :request do
  let(:inbound_params) do
    {
      headers: '...',
      from: 'John <from@example.com>',
      to: ['to@putsbox.com'],
      subject: 'Hello',
      text: 'Lorem Ipsum',
      html: '<p>Lorem Ipsum</p>',
      envelope: { to: ['to@putsbox.com'], from: 'from@example.com' }.to_json
    }.with_indifferent_access
  end

  it 'creates a new bucket' do
    expect {
      post '/record', inbound_params
    }.to change(Bucket, :count).by(1)

    expect(response).to be_ok
  end

  context 'when bucket already exists' do
    let!(:bucket) { Bucket.create(token: 'to') }

    it 'updates a bucket' do
      expect {
        post '/record', inbound_params
      }.to change(Bucket, :count).by(0)

      expect(bucket.reload.emails_count).to eq(1)
      expect(response).to be_ok
    end
  end
end
