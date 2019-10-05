import requests
import re
import urllib
import locale
import sys

url = 'http://web.ion.ru/food/FD_tree_grid.aspx'

headers = {
	'User-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0',
	'Referer': 'http://web.ion.ru/food/FD_tree_grid.aspx',
	'Content-Type': 'application/x-www-form-urlencoded'}
test = requests.get(url, headers=headers)
#print test.text.encode("windows-1251", errors='replace')

# <input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="BA60E8D6" />
inputs = re.findall(r'<input.*?name="(.*?)".*?value="(.*?)".*?/>', test.text)
params ={}
for i in inputs:
	params[str(i[0])] = i[1]
params['TV_1_SelectedNode']='TV_1t0'

"""
<table cellpadding="0" cellspacing="0" style="border-width:0;"><tr>
<td><div style="width:20px;height:1px"></div></td><td><div style="width:20px;height:1px"></div></td><td><img src="/WebResource.axd?d=ijBv6H4yzuozIBBc1bqiBKgJuxKQ2aEEl4uH61xK4OIztYv2a3myLXQSS4FU9yXPkbbEnp8XjrxixYBApjR4vus1cCIBH8dZKBUU5aRrWi02eSSp0&amp;t=636271779297880478" alt="" /></td><td class="TV_1_2 TV_1_8" onmouseover="TreeView_HoverNode(TV_1_Data, this)" onmouseout="TreeView_UnhoverNode(this)" style="white-space:nowrap;"><a class="TV_1_0 TV_1_1 TV_1_7" href="javascript:__doPostBack('TV_1','s1283\\1290\\1302')" onclick="TreeView_SelectNode(TV_1_Data, this,'TV_1t1301');" id="TV_1t1301">xxx</a></td></tr></table>
"""
data = re.findall(r'<a class=".*?__doPostBack\(\'(.*?)\',\'(.*?)\'.*?>(.*?)</a>', test.text)
i = 1
j = 1
products = {}
nutrients = {}
ninp = {}
locale.setlocale(locale.LC_ALL, 'Russian')
for e in data:
	params['__EVENTTARGET'] = e[0].decode('string_escape')
	params['__EVENTARGUMENT'] = e[1].decode('string_escape')
	item = requests.post(url, headers=headers, data=urllib.urlencode(params), cookies=test.cookies)
	#<td>xxx</td><td align="center">74,1</td>
	values = re.findall(r'<td>(.*?)</td><td a.*?>(.*?)</td>', item.text)
	#print e[0], e[1], e[2].encode("windows-1251", errors='replace'), len(values)
	sys.stderr.write("Quering " + e[2].encode("windows-1251", errors='replace') + "\n")
	if len(values) == 0:
		continue
	products[i] = e[2].encode("windows-1251", errors='replace')
	ninp[i] = {}
	for v in values:
		nn = v[0].encode("windows-1251", errors='replace')
		if not nn in nutrients:
			sys.stderr.write("New nutrient " + nn + "\n")
			nutrients[nn] = (j, '30')
			j = j + 1
		idx = nutrients[nn]
		try:
			ninp[i][idx] = locale.atof(v[1].encode("windows-1251", errors='replace'))
		except:
			ninp[i][idx] = 0
		#print i, idx, ninp[i][idx]
	#print item.text.encode("windows-1251", errors='replace')
	i = i + 1


print 'DELETE FROM food'
print 'DELETE FROM foodParameter'
print 'DELETE FROM foodContent'
print
for e in products:
	print "INSERT OR REPLACE INTO food VALUES({},1,'{}',30,'',1);".format(e, products[e])
print
for e in nutrients:
	n = nutrients[e]
	print "INSERT OR REPLACE INTO foodParameter VALUES({},NULL,1,{},'{}',NULL,NULL,'');".format(n[0], n[1], e)
print
for e in ninp:
	for f in ninp[e]:
		print "INSERT OR REPLACE INTO foodContent VALUES({}, {}, {}, '');".format(e, f[0], ninp[e][f])
