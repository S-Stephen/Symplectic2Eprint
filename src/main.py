from lxml import etree
import urllib.request 
import argparse




parser = argparse.ArgumentParser(description='credentials for request')
parser.add_argument('credentials', help='password')
args = parser.parse_args()

relurl = "https://"+args.credentials+"@elements.admin.cam.ac.uk:8092/elements-api/v5.5/relationship/2002783"
print(relurl)

fp = urllib.request.urlopen(relurl)
mybytes = fp.read()

'''
mystr = mybytes.decode("utf8")
fp.close()

print(mystr)

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

'''