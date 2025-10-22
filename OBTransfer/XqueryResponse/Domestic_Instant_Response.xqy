xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/DOMESTIC_TRANSFER_NEFT";
(:: import schema at "../Schema/DOMESTIC_TRANSFER_NEFT.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/instantTransfer";
(:: import schema at "../Schema/InstantTransfer.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
   
        <ns2:data>
     <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId>{fn:data($Request/ns1:operationData/ns1:PTFZ_O_0001)}</ns2:externalReferenceId>
             <ns2:status>  {
                    if (fn:data($Request/ns1:errorCode) = '0')
                    then 'SUCCESS'
                    else 'FAILURE'
                  }</ns2:status>                
            {if(fn:data($Request/ns1:errorCode) = '0') then () else(
            <ns2:errorList>
                <ns2:code></ns2:code>
                <ns2:message></ns2:message>
            </ns2:errorList>) } 
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        </ns2:data>
    </ns2:Response>
};

local:func($Request)