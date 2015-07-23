require_relative 'folders'
require_relative 'git_tasks'
require_relative 'static_generator'
require_relative 's3_publisher'

module SequenceProcessor
  class << self
    def process(sequence)
      puts 'Creating folders...'
      folders = Folders.new(:src_clone, :compiled, :dest_clone)

      puts 'Cloning source repository...'
      GitTasks.clone(sequence['src_repo'], sequence['src_branch'], folders[:src_clone])

      puts 'Running static site generator...'
      StaticGenerator.generate(sequence['gen_type'], folders)

      puts 'Publishing...'
      S3Publisher.publish(sequence['s3'], folders)
      GitTasks.publish(sequence['dest_repo'], sequence['dest_branch'], folders)

      puts 'Cleaning up....'
      folders.clean_up

      puts "Sequence #{sequence['route']} complete!"
    end
  end
end
