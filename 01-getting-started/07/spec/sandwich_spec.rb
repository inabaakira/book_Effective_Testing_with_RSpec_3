#!/usr/bin/env ruby
#-*- mode: ruby; coding: utf-8 -*-
# file: sandwich_spec.rb
#    Created:       <2019/06/26 21:32:56>
#    Last Modified: <2019/06/26 23:59:59>

Sandwich = Struct.new(:taste, :toppings)

def sandwich
  @sandwich ||= Sandwich.new('delicious', [])
end

RSpec.describe 'An ideal sandwich' do
  it 'is delicious' do
    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
