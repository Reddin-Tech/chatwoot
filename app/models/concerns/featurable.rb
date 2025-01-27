module Featurable
  extend ActiveSupport::Concern

  QUERY_MODE = {
    flag_query_mode: :bit_operator,
    check_for_column: false
  }.freeze

  # Carrega features base e enterprise
  FEATURE_LIST = begin
    base_features = YAML.safe_load(Rails.root.join('config/features.yml').read)
    
    # Se o modo enterprise estiver habilitado, carrega e combina as features enterprise
    if ChatwootApp.enterprise?
      enterprise_features = YAML.safe_load(Rails.root.join('enterprise/app/helpers/super_admin/features.yml').read)
      
      # Converte features enterprise para o formato base
      enterprise_list = enterprise_features.map do |key, feature|
        {
          'name' => key,
          'enabled' => true,
          'premium' => true,
          'enterprise' => true,
          'description' => feature['description']
        }
      end
      
      # Combina as listas
      base_features + enterprise_list
    else
      base_features
    end.freeze
  end

  FEATURES = FEATURE_LIST.each_with_object({}) do |feature, result|
    result[result.keys.size + 1] = "feature_#{feature['name']}".to_sym
  end

  included do
    include FlagShihTzu
    has_flags FEATURES.merge(column: 'feature_flags').merge(QUERY_MODE)

    before_create :enable_default_features
  end

  def enable_features(*names)
    names.each do |name|
      send("feature_#{name}=", true)
    end
  end

  def enable_features!(*names)
    enable_features(*names)
    save
  end

  def disable_features(*names)
    names.each do |name|
      send("feature_#{name}=", false)
    end
  end

  def disable_features!(*names)
    disable_features(*names)
    save
  end

  def feature_enabled?(name)
    send("feature_#{name}?")
  end

  def all_features
    FEATURE_LIST.pluck('name').index_with do |feature_name|
      feature_enabled?(feature_name)
    end
  end

  def enabled_features
    all_features.select { |_feature, enabled| enabled == true }
  end

  def disabled_features
    all_features.select { |_feature, enabled| enabled == false }
  end

  private

  def enable_default_features
    config = InstallationConfig.find_by(name: 'ACCOUNT_LEVEL_FEATURE_DEFAULTS')
    return true if config.blank?

    features_to_enabled = config.value.select { |f| f[:enabled] }.pluck(:name)
    enable_features(*features_to_enabled)
  end
end
