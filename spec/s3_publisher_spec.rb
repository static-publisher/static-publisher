require 's3_publisher'
require 'fileutils'
require 'folders'
require_relative 'fixtures'

describe S3Publisher do
  let(:opts) { Fixtures.sequence['s3'].merge(proxy: { host: '127.0.0.1', port: '4567' }) }
  let(:folders) { Folders.new(:compiled) }

  after { folders.clean_up }

  def objects(service)
    service.buckets.find('my-bucket').objects
  end

  def touch_compiled(*args)
    *args = folders[:compiled], *args
    FileUtils.mkdir_p(File.join(*args[0..-2]))
    FileUtils.touch(File.join(*args))
  end

  it 'publishes compiled folder to s3 bucket' do
    touch_compiled('lilly.txt')
    service = S3Publisher.publish(opts, folders)
    expect(objects(service).map(&:key)).to eql(['lilly.txt'])
  end

  it 'overwrites previous publish' do
    touch_compiled('cola.txt')
    service = S3Publisher.publish(opts, folders)
    expect(objects(service).map(&:key)).to eql(['cola.txt'])
  end

  it 'publishes subdirectories' do
    touch_compiled('lib', 'lola.txt')
    service = S3Publisher.publish(opts, folders)
    expect(objects(service).map(&:key)).to eql(['lib/lola.txt'])
  end

  it 'uses correct content-type' do
    skip 'fakes3 does not provide content-type support'
    touch_compiled('george.txt')
    touch_compiled('gary.html')
    service = S3Publisher.publish(opts, folders)
    expect(objects(service).map(&:content_type)).to eql(['text/plain', 'text/html'])
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
