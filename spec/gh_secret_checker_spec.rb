require 'gh_secret_checker'

describe GHSecretChecker do
  subject { GHSecretChecker.check(secret, body, gh_signature) }
  let(:secret) { 'SuperSecretSecretShhh!!!' }
  let(:body) { '{ "ref": "refs/heads/master" }' }
  let(:gh_signature) { 'sha1=17ce7421f603f00ff16812eac9aa763613eb08e4' }

  describe '.check' do
    context 'with correct signature' do
      it { expect(subject).to be(true) }
    end

    context 'with incorrect signature' do
      let(:gh_signature) { 'YOLO' }
      it { expect { subject }.to raise_error(SignatureError) }

      context 'without secret' do
        let(:secret) { nil }
        it { expect(subject).to be(true) }
      end
    end

    context 'with nil body and provided signature' do
      let(:body) { nil }
      let(:gh_signature) { nil }
      it { expect { subject }.to raise_error(SignatureError) }
    end
  end
end
