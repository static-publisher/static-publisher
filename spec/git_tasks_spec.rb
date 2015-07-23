require 'git_tasks'
require 'folders'

describe GitTasks do
  let(:test_repo) { 'https://github.com/static-publisher/test-repo' }
  after { folders.clean_up }

  describe '#clone' do
    let(:folders) { Folders.new(:clone) }

    it 'clones repo and checks out correct branch' do
      g = GitTasks.clone(test_repo, 'doctor', folders[:clone])
      expect(g.ls_files.keys).to eql(['amazing-annie'])
    end

    it 'creates branch if it does not exist' do
      g = GitTasks.clone(test_repo, 'slave', folders[:clone])
      expect(g.current_branch).to eql('slave')
    end
  end

  describe '#publish' do
    let(:folders) { Folders.new(:remote, :compiled, :dest_clone) }

    before do
      GitTasks.clone(test_repo, 'master', folders[:remote])
      FileUtils.touch(File.join(folders[:compiled], '.beautiful-beatrix'))
      FileUtils.mkdir(File.join(folders[:compiled], 'bin'))
      FileUtils.touch(File.join(folders[:compiled], 'bin', 'bedraggled-benjamin'))
    end

    it 'publishes compiled to remote' do
      GitTasks.publish(folders[:remote], 'gh-pages', folders)
      g = Git.open(folders[:remote])
      g.checkout('gh-pages')
      expect(g.ls_files.keys).to eql(['.beautiful-beatrix', 'bin/bedraggled-benjamin'])
    end

    it 'ignores if repo and branch not provided' do
      GitTasks.publish(nil, nil, folders)
      expect(Git.open(folders[:remote]).is_branch?('gh-pages')).to be(false)
    end
  end
end
