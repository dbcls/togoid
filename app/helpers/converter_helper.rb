module ConverterHelper
  def hit_count_message(display_count, hits_count)
    msg = "Showing #{number_with_delimiter(display_count)} of #{number_with_delimiter(hits_count)} results"
    content_tag(:p, msg)
  end
end
