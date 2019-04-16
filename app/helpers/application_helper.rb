module ApplicationHelper
  module SearchMethods
    Item = Struct.new(:label, :path)

    IDNAVIGATOR = Item.new('ID Navigator', :root_path)
    IDCONVERTER = Item.new('ID Converter', :convert_index_path)
    IDRESOLVER = Item.new('ID Resolver', :convert_index_path)

    def self.each
      [ID_NAVIGATOR, ID_CONVERTER, ID_RESOLVER].each { |x| yield x } if block_given?
    end
  end
end
