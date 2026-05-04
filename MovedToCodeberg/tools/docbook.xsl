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
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="https://cdn.docbook.org/release/xsltng/current/xslt/docbook.xsl"/>
<!--
<xsl:import href="/Volumes/Projects/docbook/xslTNG/build/xslt/docbook.xsl"/>
-->

<xsl:param name="persistent-toc" select="'true'"/>

<xsl:param name="section-toc-depth" select="1"/>

<xsl:param name="resource-base-uri" select="'/'"/>

<xsl:variable name="v:user-title-properties" as="element()*">
  <title xpath="self::db:chapter"
         label="false"/>
  <title xpath="self::db:section"
         label="false"/>
</xsl:variable>

<xsl:param name="chunk-section-depth" select="1"/>
<xsl:param name="chunk-include" as="xs:string*"
           select="('parent::db:book',
                   'self::db:section[parent::db:chapter[@xml:id=''config-settings'']]')"/>
<xsl:param name="chunk-exclude" as="xs:string*"
           select="('self::db:partintro',
                   'self::*[ancestor::db:partintro]',
                   'self::db:annotation',
                   'self::db:toc')"/>

<xsl:template match="rddl:resource" mode="m:docbook">
  <rddl:resource>
    <xsl:sequence select="@*"/>
    <xsl:apply-templates select="node()" mode="m:docbook"/>
  </rddl:resource>
</xsl:template>

<xsl:template match="*" mode="m:html-head-links">
  <link rel="icon" href="/img/xr.png"/>
  <link rel="stylesheet" href="/css/resolver.css"/>
  <script src="/js/boxes.js" defer="defer"/>
</xsl:template>

<xsl:template match="db:itemizedlist[@role='java']" mode="m:docbook" priority="10">
  <div class="proptable java">
    <div class="listnav">
      <span class="logo"><img src="img/java.png" alt="Java logo"/></span>
      <h3>Configuration on Java</h3>
    </div>
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="db:itemizedlist[@role='net']" mode="m:docbook" priority="10">
  <div class="proptable net">
    <div class="listnav">
      <span class="logo"><img src="img/dotNET.png" alt=".NET logo"/></span>
      <h3>Configuration on .NET</h3>
    </div>
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template name="t:top-nav">
  <xsl:param name="chunk" as="xs:boolean"/>
  <xsl:param name="node" as="element()"/>
  <xsl:param name="prev" as="element()?"/>
  <xsl:param name="next" as="element()?"/>
  <xsl:param name="up" as="element()?"/>
  <xsl:param name="top" as="element()?"/>

  <!-- We don't have the actual DocBook sources here, so ... -->
  <xsl:variable name="lang"
                select="($node/ancestor-or-self::*/@lang/string(), $default-language)[1]"/>

  <xsl:if test="$chunk">
    <div>
      <xsl:if test="$top">
        <a href="{fp:relative-link(., $top)}">
          <xsl:sequence select="fp:l10n-token($lang, 'nav-home')"/>
        </a>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:if test="$up">
        <a href="{fp:relative-link(., $up)}">
          <xsl:sequence select="fp:l10n-token($lang, 'nav-up')"/>
        </a>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:if test="$next">
        <a href="{fp:relative-link(., $next)}">
          <xsl:sequence select="fp:l10n-token($lang, 'nav-next')"/>
        </a>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:if test="$prev">
        <a href="{fp:relative-link(., $prev)}">
          <xsl:sequence select="fp:l10n-token($lang, 'nav-prev')"/>
        </a>
      </xsl:if>
      <span class="boxes"/>
    </div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
