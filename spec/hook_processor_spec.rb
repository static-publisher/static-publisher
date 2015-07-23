require 'hook_processor'
require_relative 'fixtures'

describe HookProcessor do
  let(:hook) { Fixtures.hook }
  let(:folders) { { src_clone: 'tmp/source' } }

  it 'processes the hook' do
    allow(Folders).to receive(:new).and_return(folders)
    expect(GitTasks).to receive(:clone).with(hook['src_repo'], hook['src_branch'], 'tmp/source')
    expect(StaticGenerator).to receive(:generate).with(hook['gen_type'], folders)
    expect(S3Publisher).to receive(:publish).with(hook['s3'], folders)
    expect(GitTasks).to receive(:publish).with(hook['dest_repo'], hook['dest_branch'], folders)
    expect(folders).to receive(:clean_up)
    HookProcessor.process(hook)
  end
end
