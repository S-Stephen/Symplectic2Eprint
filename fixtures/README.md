# Fixture Files:

query root: https://elements.admin.cam.ac.uk:8092/elements-api/v5.5

#### /publications/$pub_id/relationships?types=8,9&page-size=250

relationships.xml - Downloaded from /publications/$pub_id/relationships?types=8,9&page-size=250
                    This file contains a list of relationships conected with the publication.
                    If in this file __//api:is-visible[text()="false"]__ exists the publication 
                    is to be hidden.
                    From this file 
                    (if there are any) The __//api:relationship__  ids are extracted and used to 
                    download the relationship___id__ file
                    Creators as extracted and EPrint snippet created using __extract_creators.xslt__

#### /relationships/2002783

relationship_2002783 - Downloaded from /relationships/2002783 if this includes a prefered record 
                       (ie this author has selected a prefered record; 
                       '//api:object[@category="publication"]//api:record[@is-preferred-record="true"]') 
                       we stop investigating all the relationship___id__ files.
                       Each investigated relationship___id__ file will be transformed by symplectic2eprint.xslt 
                       unless the relationship___id__ file includes a preferred tag. In which case that will be 
                       the selected file to transform. 

