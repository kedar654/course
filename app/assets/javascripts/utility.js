function replace(string, find, replace)
{
	return string.replace(new RegExp(find, 'g'), replace)
}