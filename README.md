A rails study demo about rails CRUD, turbo and API

## how to use in dev

1. Open database:

```
$ docker compose up
```

2. If you need, build and install dependency:

```
$ bundle config set --local path vendor/bundle # 将 gem 安装在项目目录下
$ bin/setup # 下载 gem, create, migrate, seed 数据库
$ bin/rails assets:precompile # 下载 assets 依赖, 编译 assets
```

3. Start dev server:

```
$ bin/dev
```

extra:

```
$ bin/rails db:migrate // 数据库迁移
$ bin/rails db:seed // 生成数据库种子
```
