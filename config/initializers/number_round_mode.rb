# config/initializers/number_round_mode.rb
# Rails 6.1: number_to_currency 等で使う丸めのデフォルトを :default に固定する
ActiveSupport.on_load(:action_view) do
  if defined?(ActiveSupport::NumberHelper::NumberToRoundedConverter::DEFAULTS)
    ActiveSupport::NumberHelper::NumberToRoundedConverter::DEFAULTS[:round_mode] = :default
  end
end
