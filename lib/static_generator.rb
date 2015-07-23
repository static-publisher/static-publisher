require 'jekyll'

module StaticGenerator
  class << self
    def generate(gen_type, folders)
      send(gen_type, folders)
    end

    private

    def jekyll(folders)
      config = Jekyll.configuration('source' => folders[:src_clone],
                                    'destination' => folders[:compiled])
      Jekyll::Site.new(config).process
    end
  end
end
