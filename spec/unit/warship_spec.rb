require 'spec_helper'

RSpec.describe Warship do
  let(:instance) { described_class.new(health, damage) }

  let(:health) { 100 }
  let(:damage) { 20 }

  context 'при создании' do
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
          expect(subject).to equal(:damaged)
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
    before(:each) do
      instance.attacked(with_damage)
    end

    describe 'здоровье' do
      subject { instance.health }

      let(:with_damage) { 120 }

      it 'должно быть меньше или равно нулю' do
        expect(subject).to be <= 0
      end
    end

    describe 'состояние' do
      subject { instance.state }

      context 'когда здоровье равно нулю' do
        let(:with_damage) { 100 }

        it { expect(instance.health).to equal(0) }

        it 'должен быть уничтожен' do
          expect(subject).to equal(:wasted)
        end
      end

      context 'когда здоровье меньше нуля' do
        let(:with_damage) { 120 }

        it { expect(instance.health).to be < 0 }

        it 'должен быть уничтожен' do
          expect(subject).to equal(:wasted)
        end
      end
    end

  end

  context 'атакует' do
    let(:attacked_object) { double }

    context 'объект который можно атаковать' do
      let(:logger) { instance_double('Logger') }

      before(:each) do
        allow(attacked_object).to receive(:attacked).with(damage)
        allow(Logger).to receive(:new).and_return(logger)
        allow(logger).to receive(:info)
      end

      after(:each) do
        instance.attack(attacked_object)
      end

      it 'должен сообщить другому объекту что он атакован' do
        expect(attacked_object).to receive(:attacked).with(damage)
      end

      it 'должен писать сведения об атаке в лог' do
        expect(logger).to receive(:info).with('One object attacked other')
      end
    end

    context 'объект который нельзя атаковать' do
      it 'должен проигнорировать этот объект' do
        expect { instance.attack(attacked_object) }.to_not raise_error
      end
    end
  end
end
