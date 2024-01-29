<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://docbook.org/ns/docbook"
                expand-text="yes"
                exclude-result-prefixes="db xs"
                version="3.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:template match="/manifest">
  <xsl:variable name="items" as="element(db:listitem)+">
    <xsl:apply-templates select="entry"/>
  </xsl:variable>

  <itemizedlist role="manifest">
    <xsl:for-each select="$items">
      <xsl:sort select="(.//db:uri)[1]"/>
      <xsl:sequence select="."/>
    </xsl:for-each>
  </itemizedlist>
</xsl:template>

<xsl:template match="entry[system and not(public)]">
  <xsl:for-each select="system">
    <listitem><simpara>System identifier: <uri>{string(.)}</uri></simpara>
    <xsl:if test="namespace">
      <simpara>Namespace: <uri>{namespace}</uri></simpara>
    </xsl:if>
    <xsl:if test="nature">
      <simpara>RDDL nature: <uri>{nature}</uri></simpara>
    </xsl:if>
    <xsl:if test="purpose">
      <simpara>RDDL purpose: <uri>{purpose}</uri></simpara>
    </xsl:if>
    </listitem>
  </xsl:for-each>
</xsl:template>

<xsl:template match="entry[public]">
  <xsl:for-each select="system">
    <listitem><simpara>System identifier: <uri>{string(.)}</uri></simpara>
    <simpara>Public identifier: <code>{../public}</code></simpara>
  <xsl:if test="../namespace">
    <simpara>Namespace: <uri>{../namespace}</uri></simpara>
  </xsl:if>
  <xsl:if test="../nature">
    <simpara>RDDL nature: <uri>{../nature}</uri></simpara>
  </xsl:if>
  <xsl:if test="../purpose">
    <simpara>RDDL purpose: <uri>{../purpose}</uri></simpara>
  </xsl:if>
    </listitem>
  </xsl:for-each>
</xsl:template>

<xsl:template match="entry[uri]">
  <xsl:for-each select="uri">
  <listitem><simpara>URI: <uri>{string(.)}</uri></simpara>
  <xsl:if test="../namespace">
    <simpara>Namespace: <uri>{../namespace}</uri></simpara>
  </xsl:if>
  <xsl:if test="../nature">
    <simpara>RDDL nature: <uri>{../nature}</uri></simpara>
  </xsl:if>
  <xsl:if test="../purpose">
    <simpara>RDDL purpose: <uri>{../purpose}</uri></simpara>
  </xsl:if>
  </listitem>
  </xsl:for-each>
</xsl:template>

<xsl:template match="entry">
  <xsl:message select="'Unmatched:', ."/>
</xsl:template>

</xsl:stylesheet>
