<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:let name="document-classification"
            value="/Document/@classification" />

   <sch:pattern name="Security Classification Policy">

      <sch:p>A Para's classification value cannot be more sensitive 
             than the Document's classification value.</sch:p> 

      <sch:rule context="Para[@classification='top-secret']">

         <sch:assert test="$document-classification='top-secret'">
             If there is a Para labeled "top-secret" then the Document  
             must be labeled top-secret
         </sch:assert>

      </sch:rule>

      <sch:rule context="Para[@classification='secret']">

         <sch:assert test="($document-classification='top-secret') or
                           ($document-classification='secret')">
             If there is a Para labeled "secret" then the Document  
             must be labeled either secret or top-secret
         </sch:assert>

      </sch:rule>

      <sch:rule context="Para[@classification='confidential']">

         <sch:assert test="($document-classification='top-secret') or
                           ($document-classification='secret') or 
                           ($document-classification='confidential')">
             If there is a Para labeled "confidential" then the Document  
             must be labeled either confidential, secret or top-secret
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>