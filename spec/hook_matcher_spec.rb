require 'hook_matcher'
require_relative 'fixtures'

describe HookMatcher do
  let(:hook) { Fixtures.hook }
  let(:miss) { Fixtures.hook.merge('route' => '/missed-path') }
  let(:args) { ['/test-hook', 'body', 'gh_signature'] }

  describe '.match?' do
    context 'without a secret' do
      it { expect(HookMatcher.match?(hook, *args)).to be(true) }
      it { expect(HookMatcher.match?(miss, *args)).to be(false) }
    end

    context 'with correct signature' do
      before { allow(GHSecretChecker).to receive(:check).and_return(true) }
      it { expect(HookMatcher.match?(hook, *args)).to be(true) }
      it { expect(HookMatcher.match?(miss, *args)).to be(false) }
    end

    context 'with incorrect signature' do
      before { allow(GHSecretChecker).to receive(:check).and_raise(SignatureError) }
      it { expect { HookMatcher.match?(hook, *args) }.to raise_error(SignatureError) }
      it { expect(HookMatcher.match?(miss, *args)).to be(false) }
    end
  end

  describe '.matching_indexes' do
    it 'creates an array on indexs for matching hooks' do
      hooks = [hook, miss, miss, hook, miss, hook]
      expect(HookMatcher.matching_indexes(hooks, *args)).to eql([0, 3, 5])
    end
  end
end
