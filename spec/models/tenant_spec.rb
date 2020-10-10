require 'rails_helper'

RSpec.describe Tenant, type: :model do
  let(:tenant) { FactoryBot.create(:tenant) }
  
  describe :increment_query_count do
    it 'increases query_count value by one' do
      starting_count = tenant.query_count
      tenant.increment_query_count
      expect(tenant.reload.query_count).to eq(starting_count + 1)
    end
  end

  describe :valid_key? do
    context 'with valid api key' do
      it 'increments access count' do
        expect(tenant.query_count).to eq 0
        Tenant.valid_key?(tenant.api_key)
        expect(tenant.reload.query_count).to eq 1
      end
  
      it 'returns true' do
        expect(Tenant.valid_key?(tenant.api_key)).to eq true
      end
    end
    
    context 'with invalid api key' do
      let(:wrong_key) { 'badkeyhere' }

      it 'does not increment access count' do
        expect(tenant.query_count).to eq 0
        Tenant.valid_key?(wrong_key)
        expect(tenant.reload.query_count).to eq 0
      end
  
      it 'returns false' do
        expect(Tenant.valid_key?(wrong_key)).to eq false
      end
    end
  end
end