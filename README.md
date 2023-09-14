A demo of studying CRUD operations in rails

## how to use

1. Open database:

```
$ docker compose up
```

2. Build and install dependency:

```
$ bundle config set --local path vendor/bundle 将 gem 安装在项目目录下
$ bin/setup # 下载 gem, create, migrate, seed 数据库
$ bin/rails assets:precompile # 下载 assets 依赖, 编译 assets
```

3. Start dev server:

```
$ bin/dev # bin/rails server -b 0.0.0.0 不能实时编译 assets
```