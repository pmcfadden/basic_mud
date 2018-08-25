# frozen_string_literal: true

require 'spec_helper'
require 'lib/classless_mud/dice'

RSpec.describe ClasslessMud::Dice do
  context '1d5+0' do
    before { allow(Kernel).to receive(:rand).and_return(1) }

    subject { described_class.create('1d5+0') }

    it 'should return 2' do
      expect(subject.roll).to eq 2
    end
  end

  context '2d5+0' do
    before { allow(Kernel).to receive(:rand).and_return(1) }

    subject { described_class.create('2d5+0') }

    it 'should return 4' do
      expect(subject.roll).to eq 4
    end
  end

  context '2d5+10' do
    before { allow(Kernel).to receive(:rand).and_return(1) }

    subject { described_class.create('2d5+10') }

    it 'should return 14' do
      expect(subject.roll).to eq 14
    end
  end
end
