var pb_links = "#page-links"
var pb_title = "#page-title"

function changePageBarTitle(title)
{
	var new_title = replace(title, '&amp;', '&');
	$(pb_title).text(new_title);
}

function clearLinks()
{
	$(pb_links).empty();
}

function addLink(link)
{
	if (!$(pb_links).is(':empty'))
	{
		$(pb_links).append(" | ");
	}

	$(pb_links).append(link);
}