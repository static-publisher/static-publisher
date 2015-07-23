require_relative 'gh_secret_checker'

module HookMatcher
  class << self
    def match?(hook, path, body, gh_signature)
      hook['route'] == path && GHSecretChecker.check(hook['gh_secret'], body, gh_signature)
    end

    def matching_indexes(hooks, *args)
      hooks.each_with_index.reduce([]) do |matches, (hook, i)|
        match?(hook, *args) ? matches.push(i) : matches
      end
    end
  end
end
