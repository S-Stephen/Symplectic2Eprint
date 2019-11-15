<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:api="http://www.symplectic.co.uk/publications/api" 
xmlns:atom="http://www.w3.org/2005/Atom" 
xmlns="http://eprints.org/ep2/data/2.0">
<xsl:template match="/">
        <xsl:for-each select="//api:relationship[@type-id='8'][api:is-visible='true'][api:related/api:object[@category='user']]"><!-- insert better XPath-->
                <id><xsl:value-of select="@id"/></id>
        </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>