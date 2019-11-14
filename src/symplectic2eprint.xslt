<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:api="http://www.symplectic.co.uk/publications/api" 
xmlns:atom="http://www.w3.org/2005/Atom" 
xmlns="http://eprints.org/ep2/data/2.0">

  <xsl:template match="/">
  <!-- depending on the sources available set the prefered source -->
  <!-- preference: -->
  <!-- manual verified -->
  <!-- web of science 3 -->
  <!-- scopus 7 -->
  <!-- pub med -->
  <!-- thompson -->

 <!-- api:record[@source-id=$source] -->

    <eprints> 
    <xsl:apply-templates/>
    </eprints>
  </xsl:template>

  <xsl:template match="//atom:entry">


        <xsl:variable name="source" select="0"></xsl:variable>
        <xsl:variable name="apos" select='"&apos;"'/>
        <eprint>
        <!-- common fields -->
        <userid>1</userid>
        <eprint_status>archive</eprint_status>
        <xsl:choose>
        <xsl:when test="//api:object[@type-id='2']">
                <type>book</type>
        </xsl:when>
        <xsl:when test="//api:object[@type-id='3']">
                <type>book_section</type>
        </xsl:when>
        <xsl:when test="//api:object[@type-id='4']">
                <type>conference_item</type>
        </xsl:when>
        <xsl:when test="//api:object[@type-id='5']">
                <type>article</type>
        </xsl:when>
        <xsl:when test="//api:object[@type-id='6']">
                <type>patent</type>
        </xsl:when>
        <xsl:when test="//api:object[@type-id='7']">
                <type>monograph</type>
                <monograph_type>technical_report</monograph_type>
        </xsl:when>
        <xsl:when test="//api:object[@type-id='18']">
                <type>thesis</type>
                <xsl:choose>
                        <xsl:when test="//api:field[@name='thesis-type']/api:text[text()='PhD Thesis']">
                                <thesis_type>phd</thesis_type>
                                                       </xsl:when>
                        <xsl:when test="//api:field[@name='thesis-type']/api:text[substring(text(),1,6)='Master']">
                                <thesis_type>masters</thesis_type>
                        </xsl:when>
                        <xsl:otherwise>
                                <thesis_type>other</thesis_type>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:when>
        <xsl:when test="//api:object[@type-id>7] or api:object[2>@type-id]" >
                TODO: other, proceedings, video
        </xsl:when>
        </xsl:choose>


        <eprintid><xsl:value-of select="//api:object[@category='publication']/@id"/></eprintid>
        <!--<symplectic_id><xsl:value-of select="//api:object[@category='publication']/@id"/></symplectic_id>-->
 


        <!-- TODO test for manual verified manual -->
        <!-- how do we reassign value to type? -->
        
        <xsl:choose>
                <!-- TODO go through rest of source preferences in correct order -->
                <!-- Note we need to add a template for each of these options -->
                                
                <xsl:when test='//api:record[@is-preferred-record="true"][1]'>
                        <xsl:apply-templates select='//api:record[@is-preferred-record="true"][1]'/>
                </xsl:when>
                <xsl:when test="$source > 0">
                        <xsl:apply-templates select="//api:record[@source-id=$source]"/>
                </xsl:when>

                <xsl:when test="//api:record[@source-id=1]/api:verification-status[text()='verified'][1]">
                        <!-- TODO test that this is a verified manual source -->
                        <xsl:apply-templates select="//api:record[@source-id=1][1]"/>
                </xsl:when>
                <xsl:when test="//api:record[@source-id=7][1]">
                        <!-- Scopus -->
                        <xsl:apply-templates select="//api:record[@source-id=7][1]"/>
                </xsl:when>
                <xsl:when test="//api:record[@source-id=3][1]">
                        <!-- Web of Science -->
                        <xsl:apply-templates select="//api:record[@source-id=3][1]"/>
                </xsl:when>
                <xsl:when test="//api:record[@source-id=5][1]">
                        <!-- arXiv -->
                        <xsl:apply-templates select="//api:record[@source-id=5][1]"/>
                </xsl:when>
                <xsl:when test="//api:record[@source-id=2][1]">
                        <!-- PubMed -->
                                                <xsl:apply-templates select="//api:record[@source-id=2][1]"/>
                </xsl:when>
                <xsl:when test="//api:record[@source-id=6][1]">
                        <!-- DBLP -->
                        <xsl:apply-templates select="//api:record[@source-id=6][1]"/>
                </xsl:when>


        
        </xsl:choose>

        <!--xsl:apply-templates select="//api:records"/>-->

        </eprint>
  </xsl:template> 


  <xsl:template match="//api:record[@source-id=1][1]">
        <xsl:apply-templates select="api:native"/>
  </xsl:template>
  <xsl:template match="//api:record[@source-id=2][1]">
        <xsl:apply-templates select="api:native"/>
  </xsl:template>
  <xsl:template match="//api:record[@source-id=3][1]">
        <xsl:apply-templates select="api:native"/>

          </xsl:template>
  <xsl:template match="//api:record[@source-id=5][1]">
        <xsl:apply-templates select="api:native"/>
  </xsl:template>
  <xsl:template match="//api:record[@source-id=6][1]">
        <xsl:apply-templates select="api:native"/>
  </xsl:template>
  <xsl:template match="//api:record[@source-id=7][1]">
        <xsl:apply-templates select="api:native"/>
  </xsl:template>

  <xsl:template match="api:native">
  <!--<xsl:template match="//api:record[@source-id=1]">-->
        <title><xsl:value-of select="./api:field[@name='title']"/></title>
        <!--<title><xsl:value-of select="./api:native/api:field[@name='title']"/></title>--><!--title though possibly in api:object as field = title-->
        <abstract><xsl:value-of select="./api:field[@name='abstract']"/></abstract><!--abstract though possibly in api:object as field = abstract-->
        <!--<abstract><xsl:value-of select="./api:native/api:field[@name='abstract']"/></abstract>--><!--abstract though possibly in api:object as field = abstract-->
        <!-- The notes field may hold ref woring out! so can no longer publicly display-->
        <!--<note><xsl:value-of select="./api:field[@name='notes']"/></note>-->
        <!--<note><xsl:value-of select="./api:native/api:field[@name='notes']"/></note>-->
        <creators>
                    <!-- TODO: find correct record and first authors field --><!-- in api:field with name=authors api:people foreach api:person -->
                <xsl:for-each select="./api:field[@name='authors']/api:people/api:person"> <!-- insert better XPath -->
                <!--<xsl:for-each select="./api:native/api:field[@name='authors']/api:people/api:person">--> <!-- insert better XPath -->
                <item> 
                        <name> 
                                <family><xsl:value-of select="api:last-name"/></family> 
                                <given><xsl:value-of select="api:initials"/></given> 
                        </name> 
                        <!--<id>TODO - get id</id> This is done via a seperate API call and XSL-->
                </item> 
                <xsl:text> 
                </xsl:text>
                </xsl:for-each>
        </creators>
        <editors/> 
 
        <keywords>
        <xsl:for-each select="./api:field[@name='keywords']/api:keywords/api:keyword">
        <!--<xsl:for-each select="./api:native/api:field[@name='keywords']/api:keywords/api:keyword">-->
                <xsl:value-of select="."/><xsl:text> </xsl:text>
        </xsl:for-each>
        </keywords>

        <contact_email>
                           <!-- no entity found in Symplectic schema -->
        </contact_email>
  
        <official_url>
                <!-- no entity found in Symplectic schema -->
        </official_url>
        <xsl:choose>
                <xsl:when test="./api:field[@name='publication-date']">
                <!--<xsl:when test="./api:native/api:field[@name='publication-date']">-->
                        <date_type>published</date_type>
                        <ispublished>pub</ispublished>
                        <date>
                                <xsl:value-of select="./api:field[@type='date']/api:date/api:year"/>-<xsl:value-of select="./api:field[@type='date']/api:date/api:month"/>-<xsl:value-of select="./api:field[@type='date']/api:date/api:day"/>
                                <!--<xsl:value-of select="./api:native/api:field[@type='date']/api:date/api:year"/>-<xsl:value-of select="/api:native/api:field[@type='date']/api:date/api:month"/>-<xsl:value-of select="./api:native/api:field[@type='date']/api:date/api:day"/>-->
                        </date>
                </xsl:when>
                <xsl:otherwise>
                        <ispublished>unpub</ispublished>
                </xsl:otherwise>
        </xsl:choose>


        <!-- Journal specific -->
        <!--<xsl:if test="//api:native/api:object[@type-id=5]">-->

               <xsl:if test="./api:field[@display-name='Journal']">
        <!--<xsl:if test="./api:native/api:field[@display-name='Journal']">-->
                <publication><xsl:value-of select="./api:field[@display-name='Journal']"/></publication>
                <!--<publication><xsl:value-of select="./api:native/api:field[@display-name='Journal']"/></publication>-->
        </xsl:if>
        <!--</xsl:if>-->
        
        <xsl:if test="./api:field[@display-name='Published proceedings']">
        <!--<xsl:if test="./api:native/api:field[@display-name='Published proceedings']">-->
                <publication><xsl:value-of select="./api:field[@display-name='Published proceedings']"/></publication>
                <!--<publication><xsl:value-of select="./api:native/api:field[@display-name='Published proceedings']"/></publication>-->
        </xsl:if>

        <publisher><xsl:value-of select="./api:field[@display-name='Publisher']"/></publisher>
        <!--<publisher><xsl:value-of select="./api:native/api:field[@display-name='Publisher']"/></publisher>-->
        <place_of_pub><xsl:value-of select="./api:field[@display-name='Place of publication']"/></place_of_pub>
        <!--<place_of_pub><xsl:value-of select="./api:native/api:field[@display-name='Place of publication']"/></place_of_pub>-->
        <volume><xsl:value-of select="./api:field[@display-name='Volume']"/></volume>
        <!--<volume><xsl:value-of select="./api:native/api:field[@display-name='Volume']"/></volume>-->
        <series><xsl:value-of select="./api:field[@display-name='Series']"/></series>
        <!--<series><xsl:value-of select="./api:native/api:field[@display-name='Series']"/></series>-->
        <!--<pages><xsl:value-of select="./api:native/api:field[@display-name='Pagination']"/></pages>-->
        <xsl:if test="./api:field[@display-name='Pagination']">
        <!--<xsl:if test="./api:native/api:field[@display-name='Pagination']">-->
                       <pagerange><xsl:value-of select="./api:field[@display-name='Pagination']/api:pagination/api:begin-page"/>-<xsl:value-of select="./api:field[@display-name='Pagination']/api:pagination/api:end-page"/></pagerange>
                <!--<pagerange><xsl:value-of select="./api:native/api:field[@display-name='Pagination']/api:pagination/api:begin-page"/>-<xsl:value-of select="./api:native/api:field[@display-name='Pagination']/api:pagination/api:end-page"/></pagerange>-->
        </xsl:if>
        <id_number>doi:<xsl:value-of select="./api:field[@name='doi']"/></id_number>
        <!--<id_number>doi:<xsl:value-of select="./api:native/api:field[@display-name='DOI']"/></id_number>-->
        <isbn><xsl:if test="./api:field[@name='ISBN-10']"><xsl:value-of select="./api:field[@name='ISBN-10']"/><xsl:if test="./api:field[@name='ISBN-13']">,</xsl:if></xsl:if><xsl:value-of select="./api:field[@name='ISBN-13']"/></isbn>
        <!--<isbn><xsl:if test="./api:native/api:field[@name='ISBN-10']"><xsl:value-of select="./api:native/api:field[@name='ISBN-10']"/><xsl:if test="./api:native/api:field[@name='ISBN-13']">,</xsl:if></xsl:if><xsl:value-of select="./api:native/api:field[@name='ISBN-13']"/></isbn>-->
        <issn><xsl:value-of select="./api:field[@name='issn']"/></issn>
        <!--<issn><xsl:value-of select="./api:native/api:field[@name='issn']"/></issn>-->
  
  
        <!--conf items-->
        <xsl:if test="./api:field[@display-name='Name of conference']">
        <!--<xsl:if test="./api:native/api:field[@display-name='Name of conference']">-->
                <event_title><xsl:value-of select="./api:field[@display-name='Name of conference']"/></event_title>
                <!--<event_title><xsl:value-of select="./api:native/api:field[@display-name='Name of conference']"/></event_title>-->
                <event_location><xsl:value-of select="./api:field[@display-name='Conference place']"/></event_location>
                <!--<event_location><xsl:value-of select="./api:native/api:field[@display-name='Conference place']"/></event_location>-->
                                <event_dates><xsl:value-of select="./api:field[@display-name='Conference start date']/api:date/api:year"/>-<xsl:value-of select="./api:field[@display-name='Conference start date']/api:date/api:month"/>-<xsl:value-of select="./api:field[@display-name='Conference start date']/api:date/api:day"/> to <xsl:value-of select="./api:field[@display-name='Conference finish date']/api:date/api:year"/>-<xsl:value-of select="./api:field[@display-name='Conference finish date']/api:date/api:month"/>-<xsl:value-of select="./api:field[@display-name='Conference finish date']/api:date/api:day"/> </event_dates>
                <!--<event_dates><xsl:value-of select="./api:native/api:field[@display-name='Conference start date']/api:date/api:year"/>-<xsl:value-of select="./api:native/api:field[@display-name='Conference start date']/api:date/api:month"/>-<xsl:value-of select="./api:native/api:field[@display-name='Conference start date']/api:date/api:day"/> to <xsl:value-of select="./api:native/api:field[@display-name='Conference finish date']/api:date/api:year"/>-<xsl:value-of select="./api:native/api:field[@display-name='Conference finish date']/api:date/api:month"/>-<xsl:value-of select="./api:native/api:field[@display-name='Conference finish date']/api:date/api:day"/> </event_dates>-->
                <event_type>conference</event_type>
        </xsl:if>  
        <!--book section-->
        <book_title><xsl:value-of select="./api:field[@display-name='Book title']"/></book_title>
        <!--<book_title><xsl:value-of select="./api:native/api:field[@display-name='Book title']"/></book_title>-->
        
  </xsl:template>
  
  
</xsl:stylesheet>