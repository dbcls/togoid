module ApplicationHelper
  module SearchMethods
    Item = Struct.new(:label, :path)

    Rails.application.routes.url_helpers.yield_self do |helper|
      ID_NAVIGATOR = Item.new('ID Navigator', helper.root_path)
      ID_CONVERTER = Item.new('ID Converter', helper.converter_path)
      ID_RESOLVER = Item.new('ID Resolver', helper.resolver_path)
    end

    def self.each
      [ID_NAVIGATOR, ID_CONVERTER, ID_RESOLVER].each { |x| yield x } if block_given?
    end
  end
end
