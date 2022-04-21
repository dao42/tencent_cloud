# tencent_cloud

# 使用指南

1. Gemfile引入  
```ruby
gem 'tencent_cloud', github: 'dao42/tencent_cloud'
```
2. initializers中初始化配置
```ruby
TencentCloud::Configuration.init(
    secret_id: Setting.cos_secret_id,
    secret_key: Setting.cos_secret_key,
    host: Setting.cos_host,
    region: Setting.cos_region,
    bucket: Setting.cos_bucket
  )
```
3. 调用api
```ruby
resp, err = TencentCloud::Client.get_federation_token
```
