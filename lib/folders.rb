require 'securerandom'
require 'fileutils'

class Folders
  def initialize(*keys)
    @folders = Hash[keys.map { |k| [k, File.join(TMP, "#{k}#{SecureRandom.hex}")] }]
    @folders.each { |_, f| FileUtils.mkdir_p(f) }
  end

  def clean_up
    @folders.each { |_, f| FileUtils.rm_rf(f) }
  end

  def [](k)
    @folders[k]
  end

  TMP = File.expand_path('../../tmp', __FILE__)
end
