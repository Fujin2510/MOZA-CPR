xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "ExtractosWs.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/CC_DOWNLOAD_STMT";
(:: import schema at "CC_STATEMENT_DOWNLOADOBDX.xsd" ::)

declare variable $STMT_DWNLD_RESP as element() (:: schema-element(ns1:EmitirExtractosResponse) ::) external;

declare function local:func($STMT_DWNLD_RESP as element() (:: schema-element(ns1:EmitirExtractosResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>
                {
        if (fn:data($STMT_DWNLD_RESP/ns1:output/status/codigo) = 0) 
        then 'SUCCESS' 
        else 'FAILURE'
      }
                
                </ns2:status>
               <!--<ns2:errorList></ns2:errorList>-->
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:creditCardStatement>{fn:data($STMT_DWNLD_RESP/ns1:output/fichBinario)}</ns2:creditCardStatement>
        </ns2:data>
    </ns2:Response>
};

local:func($STMT_DWNLD_RESP)