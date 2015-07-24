require 's3_publisher'
require 'fileutils'
require 'folders'
require_relative 'fixtures'

describe S3Publisher do
  let(:opts) { Fixtures.sequence['s3'].merge(proxy: { host: '127.0.0.1', port: '4567' }) }
  let(:folders) { Folders.new(:compiled) }
  after { folders.clean_up }

  it 'publishes compiled folder to s3 bucket' do
    FileUtils.mkdir_p(File.join(folders[:compiled], 'lib'))
    FileUtils.touch(File.join(folders[:compiled], 'lib', 'lola.txt'))
    service = S3Publisher.publish(opts, folders)
    bucket = service.buckets.find('my-bucket')
    expect(bucket.objects.map(&:key)).to eql(['lib/lola.txt'])
  end

  it 'overwrites previous publish' do
    FileUtils.mkdir_p(File.join(folders[:compiled], 'spec'))
    FileUtils.touch(File.join(folders[:compiled], 'spec', 'cola.txt'))
    service = S3Publisher.publish(opts, folders)
    bucket = service.buckets.find('my-bucket')
    expect(bucket.objects.map(&:key)).to eql(['spec/cola.txt'])
  end

  it 'ignores if s3 opts not given' do
    expect(S3::Service).to_not receive(:new)
    S3Publisher.publish(nil, folders)
  end

  it 'ignores if only some s3 opts are given' do
    expect(S3::Service).to_not receive(:new)
    S3Publisher.publish({ 'access_key_id' => '1AU6D78E' }, folders)
  end
end
