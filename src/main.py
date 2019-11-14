from lxml import etree
 
data = open('./symplectic2eprint.xslt')
xslt_content = data.read()
xslt_root = etree.XML(xslt_content)
dom = etree.parse('../fixtures/relationship_2002783')
transform = etree.XSLT(xslt_root)
result = transform(dom)
print(str(result))
#f = open('D:\Conversion\MACSXML_Parts.csv', 'w')
#f.write(str(result1))
#f.close()

