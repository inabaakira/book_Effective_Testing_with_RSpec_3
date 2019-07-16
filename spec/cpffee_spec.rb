#!/usr/bin/env ruby
#-*- mode: ruby; coding: utf-8 -*-
# file: cpffee_spec.rb
#    Created:       <2019/07/16 14:32:31>
#    Last Modified: <2019/07/16 14:36:11>

# frozen_string_literal: true

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  it 'costs $1' do
    expect(coffee.price).to eq(1.00)
  end

  context 'with milk' do
    before { coffee.add :milk }

    it 'costs $1.25' do
      expect(coffee.price).to eq(1.25)
    end
  end
end
