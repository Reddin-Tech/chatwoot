module SuperAdmin::AccountFeaturesHelper
  def self.account_features
    # Carrega as features base
    base_features = YAML.safe_load(Rails.root.join('config/features.yml').read)
    
    # Se o modo enterprise estiver habilitado, adiciona as features enterprise
    if ChatwootApp.enterprise?
      enterprise_features = YAML.safe_load(Rails.root.join('enterprise/app/helpers/super_admin/features.yml').read)
      # Converte features enterprise para o mesmo formato das features base
      enterprise_feature_list = enterprise_features.map do |key, _feature|
        { 'name' => key, 'premium' => true }
      end
      base_features += enterprise_feature_list
    end

    base_features
  end

  def self.account_premium_features
    account_features.select { |feature| feature['premium'] }.map { |feature| feature['name'] }
  end
end
