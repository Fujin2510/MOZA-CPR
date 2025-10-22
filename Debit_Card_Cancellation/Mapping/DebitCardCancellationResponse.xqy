xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/cpca";
(:: import schema at "../XSD/CPCA.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/DC_UPD_STATUS";
(:: import schema at "../XSD/DC_UPD_STATUS.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
     <ns2:Response>
<ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo>{fn:data($Response/ns1:operationData/ns1:CCEM_O_0001)}</ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{if(fn:data($Response/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status>
            <ns2:errorList></ns2:errorList>
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
</ns2:data>
    </ns2:Response>
};

local:func($Response)