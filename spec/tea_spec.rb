#!/usr/bin/env ruby
#-*- mode: ruby; coding: utf-8 -*-
# file: tea_spec.rb
#    Created:       <2019/07/16 17:44:12>
#    Last Modified: <2019/07/16 17:56:39>

# frozen_string_literal: true

class Tea
  def flavor
    :earl_gray
  end

  def temperature
    205.0
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec.describe Tea do
  let(:tea) { Tea.new }

  it 'tastes like Earl Grey' do
    expect(tea.flavor).to be :earl_gray
  end

  it 'is hot' do
    expect(tea.temperature).to be > 200.0
  end
end
