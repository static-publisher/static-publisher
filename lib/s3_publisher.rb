require 's3'
require 'mime-types'

module S3Publisher
  class << self
    def publish(opts, folders)
      return unless publish?(opts)
      service = S3::Service.new(symbolize_keys(opts))
      bucket = find_or_create_bucket(service, opts['bucket'], opts['region'])
      bucket.objects.destroy_all
      upload_files(bucket, folders[:compiled], opts['cache_control'])
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

    def upload_files(bucket, folder, cache_control)
      files(folder).each do |file|
        object = bucket.objects.build(key(folder, file))
        object.content_type = mime_type(file)
        object.content = File.read(file)
        object.cache_control = cache_control
        object.save
      end
    end

    def files(folder)
      Dir[File.join(folder, '**', '{*,.*}')].select { |f| File.file?(f) }
    end

    def key(folder, file)
      file.sub(folder, '').sub(/^[\/\\]/, '')
    end

    def mime_type(file)
      MIME::Types.type_for(File.extname(file)).first.to_s
    end
  end
end
