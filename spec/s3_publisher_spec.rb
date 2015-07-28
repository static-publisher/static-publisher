require 's3_publisher'
require 'fileutils'
require 'folders'
require_relative 'fixtures'

describe S3Publisher do
  let(:opts) { Fixtures.sequence['s3'].merge(proxy: { host: '127.0.0.1', port: '4567' }) }
  let(:folders) { Folders.new(:compiled) }

  after { folders.clean_up }

  def files(service)
    service.buckets.find('my-bucket').objects.map(&:key)
  end

  def touch_compiled(*args)
    FileUtils.mkdir_p(File.join(folders[:compiled], *args, '..'))
    FileUtils.touch(File.join(folders[:compiled], *args))
  end

  it 'publishes compiled folder to s3 bucket' do
    touch_compiled('lilly.txt')
    service = S3Publisher.publish(opts, folders)
    expect(files(service)).to eql(['lilly.txt'])
  end

  it 'overwrites previous publish' do
    touch_compiled('cola.txt')
    service = S3Publisher.publish(opts, folders)
    expect(files(service)).to eql(['cola.txt'])
  end

  it 'publishes subdirectories' do
    touch_compiled('lib', 'lola.txt')
    service = S3Publisher.publish(opts, folders)
    expect(files(service)).to eql(['lib/lola.txt'])
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
