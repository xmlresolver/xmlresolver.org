<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="db xs"
                version="3.0">

<xsl:output method="xml" encoding="utf-8" indent="no"/>

<xsl:template match="/">
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

<xsl:template match="db:sysprop">
  <property role="system">
    <xsl:copy-of select="@* except @role"/>
    <xsl:apply-templates/>
  </property>
</xsl:template>

<xsl:template match="db:fprop">
  <property role="file">
    <xsl:copy-of select="@* except @role"/>
    <xsl:apply-templates/>
  </property>
</xsl:template>

</xsl:stylesheet>
