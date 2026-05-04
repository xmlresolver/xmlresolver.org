<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs html"
                version="3.0">

<!-- rddl:resources must be children of body -->

<xsl:output method="xhtml" omit-xml-declaration="yes" encoding="utf-8" indent="no"/>

<xsl:template match="html:html">
  <xsl:copy>
    <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
    <xsl:namespace name="rddl" select="'http://www.rddl.org/'"/>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="html:main|html:article">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="html:section[descendant::rddl:resource]
                     | html:div[descendant::rddl:resource]"
              xmlns:rddl="http://www.rddl.org/">
  <xsl:if test="@id">
    <a name="{@id}" id="{@id}"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
