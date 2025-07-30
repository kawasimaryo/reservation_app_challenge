# Ruby 3.3.3 対応モンキーパッチ
# ActiveSupport::LoggerThreadSafeLevel::Logger が見つからない問題を修正

unless defined?(::Logger)
  require 'logger'
end

module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger

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

