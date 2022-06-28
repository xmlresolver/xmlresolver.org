<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/ns/docbook/functions"
                xmlns:fp="http://docbook.org/ns/docbook/functions/private"
                xmlns:m="http://docbook.org/ns/docbook/modes"
                xmlns:mp="http://docbook.org/ns/docbook/modes/private"
                xmlns:rddl="http://www.rddl.org/"
                xmlns:t="http://docbook.org/ns/docbook/templates"
                xmlns:tp="http://docbook.org/ns/docbook/templates/private"
                xmlns:v="http://docbook.org/ns/docbook/variables"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="https://cdn.docbook.org/release/xsltng/current/xslt/docbook.xsl"/>
<!--
<xsl:import href="/Users/ndw/Projects/docbook/xslTNG/build/xslt/docbook.xsl"/>
-->

<xsl:param name="persistent-toc" select="'true'"/>

<xsl:param name="section-toc-depth" select="1"/>

<xsl:param name="resource-base-uri" select="'/'"/>

<xsl:param name="css-links"
           select="'css/docbook.css css/docbook-screen.css css/resolver.css'"/>

<xsl:variable name="v:user-title-properties" as="element()*">
  <title xpath="self::db:chapter"
         label="false"/>
  <title xpath="self::db:section"
         label="false"/>
</xsl:variable>

<xsl:param name="chunk-section-depth" select="0"/>
<xsl:param name="chunk-include" as="xs:string*"
           select="('parent::db:book')"/>

<xsl:template match="rddl:resource" mode="m:docbook">
  <rddl:resource>
    <xsl:sequence select="@*"/>
    <xsl:apply-templates select="node()" mode="m:docbook"/>
  </rddl:resource>
</xsl:template>

<xsl:template match="*" mode="m:html-head-links">
  <link rel="icon" href="/img/xr.png"/>
</xsl:template>

<xsl:template match="db:itemizedlist[@role='java']" mode="m:docbook" priority="10">
  <div class="proptable java">
    <div class="listnav">
      <span class="logo"><img src="/img/java.png" alt="Java logo"/></span>
      <h3>Configuration on Java</h3>
    </div>
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="db:itemizedlist[@role='net']" mode="m:docbook" priority="10">
  <div class="proptable net">
    <div class="listnav">
      <span class="logo"><img src="/img/dotNET.png" alt=".NET logo"/></span>
      <h3>Configuration on .NET</h3>
    </div>
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="processing-instruction('settings-toc')" mode="m:docbook">
  <xsl:variable name="chapter" select=".."/>
  <xsl:variable name="features"
                select="distinct-values($chapter//db:constant/text())"/>
  <ul>
    <xsl:for-each select="$features">
      <xsl:sort select="."/>
      <xsl:variable name="name" select="."/>

      <xsl:variable name="constant"
                    select="($chapter//db:constant[. = $name])[1]"/>
      <xsl:variable name="section"
                    select="$constant/ancestor::*[@xml:id][1]"/>

      <li>
        <a href="#{$section/@xml:id}">
          <xsl:sequence select="."/>
        </a>
        <xsl:if test="starts-with($section/@role, 'since-')">
          <xsl:text> (Since </xsl:text>
          <xsl:value-of select="substring-after($section/@role, 'since-')"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </li>
    </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>
