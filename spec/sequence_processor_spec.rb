require 'sequence_processor'
require_relative 'fixtures'

describe SequenceProcessor do
  let(:sequence) { Fixtures.sequence }
  let(:folders) { { src_clone: 'tmp/source' } }

  it 'processes the sequence' do
    allow(Folders).to receive(:new).and_return(folders)

    args = [sequence['src_repo'], sequence['src_branch'], 'tmp/source']
    expect(GitTasks).to receive(:clone).with(*args)

    expect(StaticGenerator).to receive(:generate).with(sequence['gen_type'], folders)
    expect(S3Publisher).to receive(:publish).with(sequence['s3'], folders)

    args = [sequence['dest_repo'], sequence['dest_branch'], folders]
    expect(GitTasks).to receive(:publish).with(*args)

    expect(folders).to receive(:clean_up)
    SequenceProcessor.process(sequence)
  end
end
