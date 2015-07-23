require 'static_generator'
require 'folders'
require 'git'

describe StaticGenerator do
  let(:folders) { Folders.new(:src_clone, :compiled) }
  after { folders.clean_up }

  describe '#jekyll' do
    before { Git.clone('https://github.com/static-publisher/test-jekyll', folders[:src_clone]) }

    it 'generates jekyll project to compiled folder' do
      StaticGenerator.generate(:jekyll, folders)
      index_file = File.read(File.join(folders[:compiled], 'index.txt'))
      expected = 'Simple Jekyll Project - Basically as simple as you can make really.'
      expect(index_file).to eq(expected)
    end
  end
end
