source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Rubyバージョン
ruby '3.3.3'

# Rails本体
gem 'rails', '6.1.3.2'

# SQLite3（Ruby 3.3対応）
gem 'sqlite3', '~> 1.6.6'

# アプリケーションサーバー
gem 'puma', '~> 5.0'

# SCSS対応
gem 'sass-rails', '>= 6'

# JavaScript管理（Rails 6用）
gem 'webpacker', '~> 5.4'

# フロントエンド系
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'

# 起動高速化
gem 'bootsnap', '>= 1.4.4', require: false

# Ruby 3.3系で必要な標準ライブラリ
gem 'bigdecimal', '~> 3.2.2'
gem 'mutex_m', '~> 0.3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # SpringはRuby 3.3ではエラーを起こすので削除 or コメントアウト
  # gem 'spring'
end

# Windows用
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'