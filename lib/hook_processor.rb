require_relative 'folders'
require_relative 'git_tasks'
require_relative 'static_generator'
require_relative 's3_publisher'

module HookProcessor
  class << self
    def process(hook)
      puts 'Creating folders...'
      folders = Folders.new(:src_clone, :compiled, :dest_clone)

      puts 'Cloning source repository...'
      GitTasks.clone(hook['src_repo'], hook['src_branch'], folders[:src_clone])

      puts 'Running static site generator...'
      StaticGenerator.generate(hook['gen_type'], folders)

      puts 'Publishing...'
      S3Publisher.publish(hook['s3'], folders)
      GitTasks.publish(hook['dest_repo'], hook['dest_branch'], folders)

      puts 'Cleaning up....'
      folders.clean_up

      puts "Hook #{hook['route']} complete!"
    end
  end
end
