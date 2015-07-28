require 's3'

module S3Publisher
  class << self
    def publish(opts, folders)
      return unless publish?(opts)
      service = S3::Service.new(symbolize_keys(opts))
      bucket = find_or_create_bucket(service, opts['bucket'], opts['region'])
      bucket.objects.destroy_all
      upload_files(bucket, folders[:compiled])
      service
    end

    private

    def symbolize_keys(hash)
      Hash[hash.map { |k, v| [k.to_sym, v] }]
    end

    def publish?(opts)
      opts && opts['access_key_id'] && opts['secret_access_key'] && opts['bucket']
    end

    def find_or_create_bucket(service, name, region)
      service.buckets.find(name) ||
        service.buckets.build(name).tap { |b| b.save(location: region) }
    end

    def upload_files(bucket, folder)
      files(folder).each do |f|
        key = f.sub(folder, '').sub(/^[\/\\]/, '')
        bucket.objects.build(key).tap { |o| o.content = File.read(f) }.save
      end
    end

    def files(folder)
      Dir[File.join(folder, '**', '{*,.*}')].select { |f| File.file?(f) }
    end
  end
end
