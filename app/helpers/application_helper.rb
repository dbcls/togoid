module ApplicationHelper
  module SearchMethods
    Item = Struct.new(:label, :path)

    ID_NAVIGATOR = Item.new('ID Navigator', :root_path)
    ID_CONVERTER = Item.new('ID Converter', :converter_path)
    ID_RESOLVER = Item.new('ID Resolver', :resolver_path)

    def self.each
      [ID_NAVIGATOR, ID_CONVERTER, ID_RESOLVER].each { |x| yield x } if block_given?
    end
  end
end
