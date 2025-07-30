# config/initializers/webpacker_monkey_patch.rb

# Ruby 3.1+ と Bundler 新仕様の互換性対応モンキーパッチ
# webpacker/lib/webpacker/command.rb の load に対応

if defined?(Webpacker::Compiler)
  require 'webpacker/command'

  module Webpacker
    class << self
      alias_method :old_instance, :instance

      def instance
        @instance ||= begin
          config = Webpacker::Configuration.new(
            root_path: Rails.root,
            config_path: Rails.root.join("config", "webpacker.yml")
          )
          Webpacker::Instance.new(config)
        end
      end
    end
  end
end

