#!/usr/bin/env ruby
#-*- mode: ruby; coding: utf-8 -*-
# file: cpffee_spec.rb
#    Created:       <2019/07/16 14:32:31>
#    Last Modified: <2019/07/16 17:08:47>

# frozen_string_literal: true

class Coffee
  def ingredients
    @ingredients ||= []
  end

  def add(ingredient)
    ingredients << ingredient
  end

  def price
    1.00 + ingredients.size * 0.25
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

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

    it 'is light in color'
    it 'is cooler than 200 degrees Fahrenheit'
  end
end
