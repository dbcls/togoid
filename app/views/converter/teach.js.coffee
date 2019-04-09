sampleIds = <%=raw @identifiers.uniq.to_json %>

$('textarea#identifiers').val(sampleIds.join("\n"))
$('div#add-new-id').addClass 'sample'

`<%=raw render(template: 'converter/convert') %>`
