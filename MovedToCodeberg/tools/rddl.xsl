<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/ns/docbook/functions"
                xmlns:fp="http://docbook.org/ns/docbook/functions/private"
                xmlns:m="http://docbook.org/ns/docbook/modes"
                xmlns:mp="http://docbook.org/ns/docbook/modes/private"
                xmlns:rddl="http://www.rddl.org/"
                xmlns:t="http://docbook.org/ns/docbook/templates"
                xmlns:tp="http://docbook.org/ns/docbook/templates/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="docbook.xsl"/>

<xsl:output method="xml"/>

<xsl:param name="css-links"
           select="'css/docbook.css css/docbook-screen.css css/rddl.css'"/>

<xsl:param name="persistent-toc" select="'true'"/>

</xsl:stylesheet>
