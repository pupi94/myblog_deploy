# production 服务器ip 登陆用户
server "127.0.0.1", user: "ping", roles: %w{app db web}, primary: true

# SSH秘钥登录 production服务器，然后每次部署的时候就不需要输入很多次密码
# 需要将部署服务器的ssh公钥添加到production 服务器的 ~/.ssh/authorized_key (没有则新建)文件中，
set :ssh_options, {
  keys: %w(~/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey)
}
