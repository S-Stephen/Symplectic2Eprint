from lxml import etree
import urllib.request 
import argparse
from urllib.error import HTTPError

def save_to_file(filename,content,fatal=False):
    """creates and writes text to a file
    
    arguments:
    filename - the path and file to create
    content - the text to be written
    fatal - true raise an exception on execption
            false prints warning and returns
    """
    try:
        fp = open(filename,"wb")
        fp.write(content)
        fp.close()
    except Exception as e:
        if fatal:
            raise Error("An issue occured saving to file: "+filename+":\n"+str(e))
        else:
            print("warning: trouble saving content to "+filename+"\n:"+str(e)) #+" content: "+str(content))
    
# authenticate with Symplectic
parser = argparse.ArgumentParser(description='credentials for request')
parser.add_argument('pub_id', help='publication (symplectic) id')
parser.add_argument('username', help='username')
parser.add_argument('password', help='password')

args = parser.parse_args()

# credit: https://stackoverflow.com/questions/44239822/urllib-request-urlopenurl-with-authentication
# Add the username and password.
# If we knew the realm, we could use it instead of None.
base_url = "https://elements.admin.cam.ac.uk:8092/elements-api/v5.5/"
password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()
password_mgr.add_password(None, base_url, args.username, args.password)
handler = urllib.request.HTTPBasicAuthHandler(password_mgr)
# create "opener" (OpenerDirector instance)
opener = urllib.request.build_opener(handler)
# use the opener to fetch a URL


opener.open(base_url)

# Install the opener.
# Now all calls to urllib.request.urlopen use our opener.
urllib.request.install_opener(opener)



# retrieve the publication from id and extract the creator relationships

pub_rels_url = base_url+"publications/"+args.pub_id+"/relationships?types=8,9&page-size=250"
# extract all the creator relationhip ids from our various relations
extract_rels = etree.XSLT(etree.XML(open('./extract_relationships.xslt').read()))

rel_ids=()
try:
    fp = urllib.request.urlopen(pub_rels_url)
    # get array of relationship ids:
    rel_ids = etree.XPath("//text()") (extract_rels(etree.fromstring(fp.read())))
    fp.close()
except HTTPError as err:
    if err.code == 404:
        print("Sorry publications ("+args.pub_id+") not found")
        exit
    else: 
        raise



# extract the relationships - and list here

extract_eprint = etree.XSLT(etree.XML(open('./symplectic2eprint.xslt').read()))
extract_creators = etree.XSLT(etree.XML(open('./extract_creators.xslt').read()))
for id in rel_ids:
    print(id)
    rel_url = "https://elements.admin.cam.ac.uk:8092/elements-api/v5.5/relationships/"+id
    print(rel_url)

    fp = urllib.request.urlopen(rel_url)
    symp_pub = fp.read()
    save_to_file("./output/"+args.pub_id+"_"+id+"_symp",symp_pub)
    # get array of relationship ids:
    #print(fp.read())
    dom = etree.fromstring(symp_pub)
    # a small document containing the creators found in the relationship
    creator_ele=extract_creators(dom)
    save_to_file("./output/"+args.pub_id+"_"+id+"_eprint",extract_eprint(dom))
    #print(eprint_pub)
    print(creator_ele)
    tree = etree.XML(str(creator_ele))
    #print(tree)
    print( etree.XPath(".//text()") (creator_ele) )
    '''
    result = etree.tostring(tree.getroot(), pretty_print=True, method="html")
    print(result)
    #print(etree.parse(str(creator_ele)).getroot().find('.//creators'))
    # insert the creators that were found (<creators> node into <eprint:creators>)
    #fp.close()


#relurl = "https://"+args.credentials+"@elements.admin.cam.ac.uk:8092/elements-api/v5.5/relationship/2002783"
relurl = "https://elements.admin.cam.ac.uk:8092/elements-api/v5.5/relationship/2002783"


# create a password manager
password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()


print(relurl)

fp = urllib.request.urlopen(relurl)
mybytes = fp.read()

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