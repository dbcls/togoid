module ApplicationHelper
  module SearchMethods
    Item = Struct.new(:label, :path)

    Rails.application.routes.url_helpers.yield_self do |helper|
      IDNAVIGATOR = Item.new('ID Navigator', helper.root_path)
      IDCONVERTER = Item.new('ID Converter', '#')
      IDRESOLVER = Item.new('ID Resolver', '#')
    end

    def self.each
      [IDNAVIGATOR, IDCONVERTER, IDRESOLVER].each { |x| yield x } if block_given?
    end
  end
end
