module Fixtures
  class << self
    def hook
      {
        'route' => '/test-hook',
        'src_repo' => 'https://github.com/other_user/cool_repo',
        'src_branch' => 'master',
        'gen_type' => 'jekyll',
        'gen_build_path' => '_site',
        's3' => {
          'access_key_id' => 'my_key',
          'secret_access_key' => 'fg4dt5r',
          'bucket' => 'my-bucket',
          'region' => 'eu-west-1'
        },
        'dest_repo' => 'https://github.com/my_user/cool_repo',
        'dest_branch' => 'gh_pages'
      }
    end
  end
end
