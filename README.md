### 一、部署环境
- centos7(阿里云服务器)
- [Capistrano 3.10](https://github.com/capistrano/capistrano)
- Ruby2.4.4
- Rails 5.2
- Puma3.11
- Nginx1.13
- Sidekiq5.1.3(monit 5.25)

ruby、nginx、redis 和monit的安装过程这里略过

### 二、初始化部署项目并配置Capistrano(以部署production环境为例)
建好部署项目后在Gemfile中添加Capistrano相关gem
```
gem "capistrano", "~> 3.10", require: false
gem 'capistrano-rails', '~> 1.3', require: false
gem 'capistrano3-puma', '~> 3.1', require: false
gem 'capistrano-sidekiq', '~> 1.0'
```
##### 初始化 capistrano
```
$ cap install
```
`cap T` 可用来查看可执行任务列表

### 三、部署项目

#### 1、检查需要的文件和目录
```
cap production deploy:check
```
根据提示创建对应文件或文件夹
##### 新建shared/config/database.yml文件
```
production:
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: root
  password: xxxxxxx
  host: localhost
  database: myblog_production
```
##### 新建master.key文件
将本地项目config/master.key中的内容复制进去。

#### 2、部署并启动puma
```
$ cap production puma:config #第一次deploy之前必须将运行此命令，否则puma无法启动
$ cap production deploy
$ cap production puma:start
```
部署之后最好检查一下puma是否正常启动
```
$ cap production puma:status
```
#### 3、有新代码提交后重新部署
```
$ cap production deploy
$ cap production puma:restart
```
