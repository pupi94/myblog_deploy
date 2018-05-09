server "localhost", user: "ping", roles: %w{app db web}, primary: true

set :ssh_options, {
   keys: %w(~/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey)
}
