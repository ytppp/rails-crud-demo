A demo of studying CRUD operations in rails

## how to use

Open database:

```
$ docker compose up
```

Build and install dependency:

```
$ bundle install --path vendor/bundle # or bundle config set --local path vendor/bundle 再 bundle install, 将 gem 安装在项目目录的vendor/bundle下
$ bin/setup # 下载 gem, create, migrate, seed 数据库
$ bin/rails assets:precompile # 下载 javascript 依赖, 编译 assets
```

Start dev server:

```
$ bin/dev # bin/rails server -b 0.0.0.0 不能实时编译 assets
```