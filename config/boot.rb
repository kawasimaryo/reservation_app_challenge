# config/boot.rb

# Ruby 3.3 + Rails 6.1 Logger 定数未定義対策
require 'logger'
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger unless const_defined?(:Logger)
  end
end

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'
require 'bootsnap/setup'
