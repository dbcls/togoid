<% if @db_links.empty? %>
$('#message').html """
  <div class='alert'>
    <i class='fa-exclamation-triangle'></i> Not found.
  </div>
"""
<% end %>

$('table#mapped-ids tbody').html "<%= j(render 'db_link_table') %>"
$('div#results_info').html "<%= hit_count_message(@display_count, @hits_count) %>"
