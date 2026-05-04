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
<!--
  <xsl:variable name="x">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:message select="$x//*[@xml:id='config-settings']"/>
  <xsl:sequence select="$x"/>
-->
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


<!-- This is a slight abuse of local conventions...we're going to
     sort some sections and expand a PI -->

<xsl:template match="db:chapter[@xml:id='config-settings']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="db:section[1]/preceding-sibling::node()"/>
    <xsl:for-each select="db:section">
      <xsl:sort select="lower-case(db:info/processing-instruction('db'))"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>

<xsl:template match="processing-instruction('settings-toc')">
  <xsl:variable name="chapter" select=".."/>
  <xsl:variable name="features"
                select="distinct-values($chapter//db:constant/text())"/>

  <para role="java">The following features and properties can be used to
  configure the resolver in Java:</para>

  <xsl:call-template name="by-feature">
    <xsl:with-param name="platform" select="'java'"/>
  </xsl:call-template>
  <xsl:call-template name="by-system-property">
    <xsl:with-param name="platform" select="'java'"/>
  </xsl:call-template>
  <xsl:call-template name="by-file-property">
    <xsl:with-param name="platform" select="'java'"/>
  </xsl:call-template>
  <xsl:call-template name="by-envar">
    <xsl:with-param name="platform" select="'java'"/>
  </xsl:call-template>

  <para role="net">The following features, properties, and environment variables
  can be used to configure the resolver in .NET:</para>

  <xsl:call-template name="by-feature">
    <xsl:with-param name="platform" select="'net'"/>
  </xsl:call-template>
  <xsl:call-template name="by-system-property">
    <xsl:with-param name="platform" select="'net'"/>
  </xsl:call-template>
  <xsl:call-template name="by-file-property">
    <xsl:with-param name="platform" select="'net'"/>
  </xsl:call-template>
  <xsl:call-template name="by-envar">
    <xsl:with-param name="platform" select="'net'"/>
  </xsl:call-template>

</xsl:template>

<xsl:template name="by-feature">
  <xsl:param name="platform" required="yes"/>

  <xsl:variable name="chapter" select=".."/>
  <xsl:variable name="features"
                select="distinct-values($chapter//db:itemizedlist[@role=$platform]//db:constant/text())"/>

  <xsl:variable name="items" as="element()*">
    <xsl:for-each select="$features">
      <xsl:sort select="."/>
      <xsl:variable name="name" select="."/>
      <xsl:variable name="constant"
                    select="($chapter//db:itemizedlist[@role=$platform]//db:constant[. = $name])[1]"/>
      <xsl:variable name="section"
                    select="$constant/ancestor::*[@xml:id][1]"/>
      <xsl:if test="$section">
        <row>
          <entry>
            <link linkend="{$section/@xml:id}">
              <xsl:value-of select="$name"/>
            </link>
          </entry>
          <entry>
            <xsl:sequence select="$section/db:info/db:title/node()"/>
            <xsl:if test="starts-with($section/@role, 'since-')">
              <xsl:text> (Since </xsl:text>
              <xsl:value-of select="substring-after($section/@role, 'since-')"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </entry>
        </row>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$items">
    <table role="{$platform}" frame="all" pgwide="1">
      <info>
        <title>Indexed by resolver feature</title>
      </info>
      <tgroup cols="2" colsep="1" rowsep="1">
        <tbody>
          <xsl:sequence select="$items"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template name="by-system-property">
  <xsl:param name="platform" required="yes"/>

  <xsl:variable name="chapter" select=".."/>
  <xsl:variable name="sysprops"
                select="distinct-values($chapter//db:itemizedlist[@role=$platform]//db:sysprop/text())"/>

  <xsl:variable name="items" as="element()*">
    <xsl:for-each select="$sysprops">
      <xsl:sort select="."/>
      <xsl:variable name="name" select="."/>
      <xsl:variable name="constant"
                    select="($chapter//db:itemizedlist[@role=$platform]//db:sysprop[. = $name])[1]"/>
      <xsl:variable name="section"
                    select="$constant/ancestor::*[@xml:id][1]"/>
      <xsl:if test="$section">
        <row>
          <entry>
            <link linkend="{$section/@xml:id}">
              <xsl:value-of select="$name"/>
            </link>
          </entry>
          <entry>
            <xsl:sequence select="$section/db:info/db:title/node()"/>
            <xsl:if test="starts-with($section/@role, 'since-')">
              <xsl:text> (Since </xsl:text>
              <xsl:value-of select="substring-after($section/@role, 'since-')"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </entry>
        </row>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$items">
    <table role="{$platform}" frame="all" pgwide="1">
      <info>
        <title>Indexed by system property</title>
      </info>
      <tgroup cols="2" colsep="1" rowsep="1">
        <tbody>
          <xsl:sequence select="$items"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template name="by-file-property">
  <xsl:param name="platform" required="yes"/>

  <xsl:variable name="chapter" select=".."/>
  <xsl:variable name="fprops"
                select="distinct-values($chapter//db:itemizedlist[@role=$platform]//db:fprop/text())"/>

  <xsl:variable name="items" as="element()*">
    <xsl:for-each select="$fprops">
      <xsl:sort select="."/>
      <xsl:variable name="name" select="."/>
      <xsl:variable name="constant"
                    select="($chapter//db:itemizedlist[@role=$platform]//db:fprop[. = $name])[1]"/>
      <xsl:variable name="section"
                    select="$constant/ancestor::*[@xml:id][1]"/>
      <xsl:if test="$section">
        <row>
          <entry>
            <link linkend="{$section/@xml:id}">
              <xsl:value-of select="$name"/>
            </link>
          </entry>
          <entry>
            <xsl:sequence select="$section/db:info/db:title/node()"/>
            <xsl:if test="starts-with($section/@role, 'since-')">
              <xsl:text> (Since </xsl:text>
              <xsl:value-of select="substring-after($section/@role, 'since-')"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </entry>
        </row>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$items">
    <table role="{$platform}" frame="all" pgwide="1">
      <info>
        <title>Indexed by file property</title>
      </info>
      <tgroup cols="2" colsep="1" rowsep="1">
        <tbody>
          <xsl:sequence select="$items"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template name="by-envar">
  <xsl:param name="platform" required="yes"/>

  <xsl:variable name="chapter" select=".."/>
  <xsl:variable name="envars"
                select="distinct-values($chapter//db:itemizedlist[@role=$platform]//db:envar/text())"/>

  <xsl:variable name="items" as="element()*">
    <xsl:for-each select="$envars">
      <xsl:sort select="."/>
      <xsl:variable name="name" select="."/>
      <xsl:variable name="constant"
                    select="($chapter//db:itemizedlist[@role=$platform]//db:envar[. = $name])[1]"/>
      <xsl:variable name="section"
                    select="$constant/ancestor::*[@xml:id][1]"/>
      <xsl:if test="$section">
        <row>
          <entry>
            <link linkend="{$section/@xml:id}">
              <xsl:value-of select="$name"/>
            </link>
          </entry>
          <entry>
            <xsl:sequence select="$section/db:info/db:title/node()"/>
            <xsl:if test="starts-with($section/@role, 'since-')">
              <xsl:text> (Since </xsl:text>
              <xsl:value-of select="substring-after($section/@role, 'since-')"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </entry>
        </row>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$items">
    <table role="{$platform}" frame="all" pgwide="1">
      <info>
        <title>Indexed by environment variable</title>
      </info>
      <tgroup cols="2" colsep="1" rowsep="1">
        <tbody>
          <xsl:sequence select="$items"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
