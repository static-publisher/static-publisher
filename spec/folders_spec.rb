require 'folders'

describe Folders do
  it 'creates and deletes folders' do
    folders = Folders.new(:my_folder)
    expect(File.directory?(folders[:my_folder])).to be(true)
    folders.clean_up
    expect(File.directory?(folders[:my_folder])).to be(false)
  end
end
