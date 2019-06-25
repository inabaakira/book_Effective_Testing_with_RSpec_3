#!/usr/bin/env ruby
#-*- mode: ruby; coding: utf-8 -*-
# file: sandwich_spec.rb
#    Created:       <2019/06/26 21:32:56>
#    Last Modified: <2019/06/26 21:46:44>

RSpec.describe 'An ideal sandwich' do
  it 'is delicious' do
    Sandwich = Struct.new(:taste, :toppings)

    sandwich = Sandwich.new('delicious', [])

    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich = Sandwich.new('delicious', [])

    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
