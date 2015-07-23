require 'sequence_matcher'
require_relative 'fixtures'

describe SequenceMatcher do
  let(:hit) { Fixtures.sequence }
  let(:miss) { Fixtures.sequence.merge('route' => '/missed-path') }
  let(:args) { ['/test-route', 'body', 'gh_signature'] }

  describe '.match?' do
    context 'without a secret' do
      it { expect(SequenceMatcher.match?(hit, *args)).to be(true) }
      it { expect(SequenceMatcher.match?(miss, *args)).to be(false) }
    end

    context 'with correct signature' do
      before { allow(GHSecretChecker).to receive(:check).and_return(true) }
      it { expect(SequenceMatcher.match?(hit, *args)).to be(true) }
      it { expect(SequenceMatcher.match?(miss, *args)).to be(false) }
    end

    context 'with incorrect signature' do
      before { allow(GHSecretChecker).to receive(:check).and_raise(SignatureError) }
      it { expect { SequenceMatcher.match?(hit, *args) }.to raise_error(SignatureError) }
      it { expect(SequenceMatcher.match?(miss, *args)).to be(false) }
    end
  end

  describe '.matching_indexes' do
    it 'creates an array on indexs for matching sequences' do
      sequences = [hit, miss, miss, hit, miss, hit]
      expect(SequenceMatcher.matching_indexes(sequences, *args)).to eql([0, 3, 5])
    end
  end
end
