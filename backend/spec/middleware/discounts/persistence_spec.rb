require 'rails_helper'

describe Discounts::Persistence do
  let(:account) { create(:account) }
  let(:customer) { create(:customer, account: account) }
  let(:category) { create(:category, account: account) }
  let(:product) { create(:product, category: category) }
  let(:name) { 'Axel Rudi Pell' }
  let(:default_params) { { name: name, amount: 0, percentage: 21 } }
  let(:params) { default_params }
  let(:discount_persistence) { described_class.new(account) }

  describe '.create' do
    subject { discount_persistence.create(params) }

    it { expect { subject }.to change{ Discount.count }.by(1) }
    it { expect(subject.name).to eql 'Axel Rudi Pell' }
    it { expect(subject.active).to be true }
    it { expect(subject.percentage.amount).to eql 21.0 }
    it { expect(subject.amount.amount).to eql 0.0 }
    it { expect(subject.start_at.to_date).to eql Date.today }
    it { expect(subject.customer).to be_nil }

    context 'when there is a customer uuid' do
      let(:params) { default_params.merge(customer_id: customer.uuid) }

      it { expect(subject.customer).to eql customer }
    end

    context 'when there is a category uuid' do
      let(:params) { default_params.merge(category_id: category.uuid) }

      it { expect(subject.category).to eql category }
    end

    context 'when there is a product uuid' do
      let(:params) { default_params.merge(product_id: product.uuid) }

      it { expect(subject.product).to eql product }
    end

    context 'when there is a minimum quantity uuid' do
      let(:params) { default_params.merge(minimum_quantity: 99) }

      it { expect(subject.minimum_quantity.amount).to eql 99 }
    end

    context 'when there is a minimum price uuid' do
      let(:params) { default_params.merge(minimum_price: 18.98) }

      it { expect(subject.minimum_price.amount).to eql 18.98 }
    end

    context 'when there is a start date' do
      let(:params) { default_params.merge(start_at: 3.weeks.ago) }

      it { expect(subject.start_at.to_date).to eql 3.weeks.ago.to_date }
    end

    context 'when there is an end date' do
      let(:params) { default_params.merge(end_at: 2.weeks.from_now) }

      it { expect(subject.end_at.to_date).to eql 2.weeks.from_now.to_date }
    end
  end

  describe '.update' do
    let(:discount) { create(:discount, account: account) }
    let(:default_params) { { id: discount.uuid, name: 'Axel Rudi Pell' } }

    subject { discount_persistence.update(params) }

    it { expect(subject.name).to eql 'Axel Rudi Pell' }
    it { expect(subject.active).to be true }
    it { expect(subject.percentage.amount).to eql discount.percentage.amount }
    it { expect(subject.amount.amount).to eql discount.amount.amount }
    it { expect(subject.start_at.to_date).to eql Date.current.beginning_of_year }
    it { expect(subject.customer).to be_nil }

    context 'when there is a customer uuid' do
      let(:params) { default_params.merge(customer_id: customer.uuid) }

      it { expect(subject.customer).to eql customer }
    end

    context 'when there is a category uuid' do
      let(:params) { default_params.merge(category_id: category.uuid) }

      it { expect(subject.category).to eql category }
    end

    context 'when there is a product uuid' do
      let(:params) { default_params.merge(product_id: product.uuid) }

      it { expect(subject.product).to eql product }
    end

    context 'when there is a minimum quantity uuid' do
      let(:params) { default_params.merge(minimum_quantity: 99) }

      it { expect(subject.minimum_quantity.amount).to eql 99 }
    end

    context 'when there is a minimum price uuid' do
      let(:params) { default_params.merge(minimum_price: 18.98) }

      it { expect(subject.minimum_price.amount).to eql 18.98 }
    end

    context 'when there is a start date' do
      let(:params) { default_params.merge(start_at: 3.weeks.ago) }

      it { expect(subject.start_at.to_date).to eql 3.weeks.ago.to_date }
    end

    context 'when there is an end date' do
      let(:params) { default_params.merge(end_at: 2.weeks.from_now) }

      it { expect(subject.end_at.to_date).to eql 2.weeks.from_now.to_date }
    end
  end
end
