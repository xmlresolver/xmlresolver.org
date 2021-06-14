<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:output method="xml" encoding="utf-8" indent="no"/>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="db:sysprop">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
  <indexterm type="sysprop">
    <primary><xsl:value-of select="."/></primary>
  </indexterm>
</xsl:template>

<xsl:template match="db:fprop">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
  <indexterm type="fprop">
    <primary><xsl:value-of select="."/></primary>
  </indexterm>
</xsl:template>

<xsl:template match="db:envar">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
  <indexterm type="envar">
    <primary><xsl:value-of select="."/></primary>
  </indexterm>
</xsl:template>

<xsl:template match="db:interfacename|db:classname|db:methodname">
  <xsl:copy>
    <xsl:apply-templates select="@* except @role,node()"/>
  </xsl:copy>

  <xsl:variable name="parts" as="xs:string+">
    <xsl:choose>
      <xsl:when test="@role">
        <xsl:sequence select="tokenize(@role, '\.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="tokenize(., '\.')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="name" as="xs:string">
    <xsl:choose>
      <xsl:when test="@role">
        <xsl:sequence select="string(.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$parts[last()]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="package" as="xs:string">
    <xsl:choose>
      <xsl:when test="@role">
        <xsl:sequence select="@role/string()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="string-join($parts[position() lt count($parts)], '.')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <indexterm type="code">
    <primary><xsl:value-of select="substring-before(local-name(.), 'name')"/></primary>
    <secondary><xsl:value-of select="$package"/></secondary>
    <tertiary><xsl:value-of select="$name"/></tertiary>
  </indexterm>

  <xsl:choose>
    <xsl:when test="self::db:methodname">
      <xsl:variable name="parts" select="tokenize(@role, '\.')"/>
      <xsl:variable name="package"
                    select="string-join($parts[position() lt count($parts)], '.')"/>
      <indexterm type="code">
        <primary>package</primary>
        <secondary><xsl:value-of select="$package"/></secondary>
      </indexterm>
    </xsl:when>
    <xsl:otherwise>
      <indexterm type="code">
        <primary>package</primary>
        <secondary><xsl:value-of select="$package"/></secondary>
      </indexterm>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:constant">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
  <xsl:choose>
    <xsl:when test="starts-with(., 'ResolverFeature.')">
      <indexterm type="constant">
        <primary>org.xmlresolver.ResolverFeature</primary>
        <secondary><xsl:value-of select="substring-after(., '.')"/></secondary>
      </indexterm>
    </xsl:when>
    <xsl:otherwise>
      <indexterm type="constant">
        <primary><xsl:value-of select="."/></primary>
      </indexterm>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
