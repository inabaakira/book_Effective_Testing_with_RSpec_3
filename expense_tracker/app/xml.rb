# frozen-string-literal: true

require 'ox'

def xml_get_response_to_obj(response)
  ret = []
  obj = Ox.load(response, mode: :hash, symbolize_keys: false)
  (obj['record'] || []).each do |elm|
    if elm.class == Hash
      hash = {  }
      elm.each { |k, v| hash[k] = _convert_to_numeric(v) }
      ret << hash
    else
      ret << elm
    end
  end
  ret
end

def xml_post_response_to_obj(response)
  ret = {}
  obj = Ox.load(response, mode: :hash, symbolize_keys: false)
  obj.each do |k, v|
    ret[k] = _convert_to_numeric(v)
  end
  ret
end

def xml_post_request_to_obj(request)
  Ox.load(request, mode: :hash, symbolize_keys: false)
end

def build_xml_post_request(expense)
  doc = Ox::Document.new(:version => '1.0')
  expense.each do |k, v|
    item = Ox::Element.new(k)
    item << v.to_s
    doc << item
  end
  Ox::dump(doc)
end

def build_xml_get_response(result)
  doc = Ox::Document.new(:version => '1.0')
  if result.empty?
    doc << Ox::Element.new('record')
    return Ox::dump(doc)
  end
  result.each do |rec|
    record = Ox::Element.new('record')
    if rec.class == Hash
      rec.each do |k, v|
        item = Ox::Element.new(k)
        item << v.to_s
        record << item
      end
    else
      record << rec
    end
    doc << record
  end
  Ox::dump(doc)
end

def _convert_to_numeric(input)
  if input.class == String and /^[0-9]*$/ =~ input
    return input.to_i
  elsif input.class == String and /^[0-9]*\.[0-9]*$/ =~ input
    return input.to_f
  end
  input
end
