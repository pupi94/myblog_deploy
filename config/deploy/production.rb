server "localhost", user: "ping", roles: %w{app db web}, primary: true

# 将本机的ssh公钥添加到production 服务器的 ~/.ssh/authorized_key 文件中，
# 然后每次部署的时候就不需要输入很多次密码
set :ssh_options, {
  keys: %w(~/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey)
}
