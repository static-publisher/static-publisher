require 'git'
require 'fileutils'

module GitTasks
  class << self
    def clone(repo, branch, folder)
      Git.clone(repo, folder).tap { |g| g.checkout(branch, new_branch: !g.is_branch?(branch)) }
    end

    def publish(repo, branch, folders)
      return unless repo && branch
      clone(repo, branch, folders[:dest_clone])
      copy_files(folders[:compiled], folders[:dest_clone])
      commit(folders[:dest_clone])
    end

    private

    def copy_files(from, to)
      files(to).each { |f| FileUtils.rm_f(f) }
      files(from).each do |f|
        folder = File.dirname(f.sub(from, to))
        FileUtils.mkdir_p(folder)
        FileUtils.cp(f, folder)
      end
    end

    def files(folder)
      Dir[File.join(folder, '**', '{*,.*}')].select { |f| File.file?(f) }
    end

    def commit(folder)
      g = Git.open(folder)
      g.add(all: true)
      g.commit_all('Static Publisher changes')
      g.push('origin', g.current_branch)
    end
  end
end
