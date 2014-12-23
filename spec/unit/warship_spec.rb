require 'spec_helper'

RSpec.describe Warship do
  let(:instance) { described_class.new(health, damage) }

  context 'при создании' do
    let(:health) { 100 }
    let(:damage) { 20 }

    describe 'здоровье' do
      subject { instance.health }

      it 'должно быть равно изначальной живучести' do
        expect(subject).to equal(health)
      end
    end

    describe 'состояние' do
      subject { instance.state }

      it 'должно быть целым' do
        expect(subject).to equal(:ok)
      end
    end
  end

  context 'атакован' do
    let(:health) { 100 }
    let(:damage) { 20 }

    before(:each) do
      instance.attacked(with_damage)
    end

    describe 'здоровье' do
      subject { instance.health }

      context 'когда демейдж integer' do
        let(:with_damage) { 50 }

        it 'должно уменьшаться на количество баллов в атаке' do
          expect(subject).to equal(health - with_damage)
        end
      end

      context 'когда демейдж string' do
        let(:with_damage) { '50' }

        it 'должно уменьшаться на количество баллов в атаке' do
          expect(subject).to equal(health - with_damage.to_i)
        end
      end
    end

    describe 'состояние' do
      subject { instance.state }

      context 'когда демейдж меньше чем живучесть' do
        let(:with_damage) { 50 }

        it 'должно целым' do
          expect(subject).to equal(:ok)
        end
      end

      context 'когда демейдж больше чем живучесть' do
        let(:with_damage) { 120 }

        it 'должен быть уничтожен' do
          expect(subject).to equal(:wasted)
        end
      end
    end
  end

  context 'уничтожен' do

  end
end
