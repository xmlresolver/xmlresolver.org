<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                name="main" version="3.1">
  <p:input port="source"/>
  <p:option name="parameters" as="map(xs:QName, xs:string)"/>

  <p:xinclude/>

  <p:xslt>
    <p:with-input port="stylesheet" href="docbook.xsl"/>
    <p:with-option name="parameters" select="$parameters"/>
  </p:xslt>

  <p:for-each>
    <p:with-input pipe="secondary"/>
    <p:store href="{base-uri(.)}"/>
  </p:for-each>

  <p:sink/>

</p:declare-step>
