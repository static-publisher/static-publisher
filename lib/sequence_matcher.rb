require_relative 'gh_secret_checker'

module SequenceMatcher
  class << self
    def match?(sequence, path, body, gh_signature)
      sequence['route'] == path &&
        GHSecretChecker.check(sequence['gh_secret'], body, gh_signature)
    end

    def matching_indexes(sequences, *args)
      sequences.each_with_index.reduce([]) do |matches, (sequence, i)|
        match?(sequence, *args) ? matches.push(i) : matches
      end
    end
  end
end
