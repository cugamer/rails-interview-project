class Tenant < ActiveRecord::Base
  before_create :generate_api_key

  def increment_query_count
    update(query_count: self.query_count + 1)
  end

  def self.valid_key?(key)
    tenant = find_by(api_key: key)
    if tenant
      tenant.increment_query_count
      return true
    end
    false
  end
  
  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
