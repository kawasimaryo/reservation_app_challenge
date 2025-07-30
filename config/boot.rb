ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "logger"        # ← これを追加！

# === ここにモンキーパッチを挿入 ===
# Ruby 3.3.3 対応モンキーパッチ：LoggerThreadSafeLevel 修正
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger unless const_defined?(:Logger)

    def self.extended(base)
      base.instance_variable_set(:@logger_level_mutex, Mutex.new)
    end

    def local_level
      Thread.current[thread_hash_key]
    end

    def local_level=(level)
      Thread.current[thread_hash_key] = level
    end

    private

    def thread_hash_key
      @thread_hash_key ||= :"#{object_id}_logger_level"
    end
  end
end
# === ここまでモンキーパッチ ===

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
