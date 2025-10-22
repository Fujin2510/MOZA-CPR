xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CC_CASH_ADVANCE";
(:: import schema at "../XSDs/CC_CASH_ADVANCE.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/CHAD";
(:: import schema at "../XSDs/CHAD.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{
                    if (fn:data($MSB_Response/ns1:errorCode) = '0')
                    then 'SUCCESS'
                    else 'FAILURE'
                  }</ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:referenceNo>{fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0001)}</ns2:referenceNo>
            <ns2:currencytype>{fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0003)}</ns2:currencytype>
            <ns2:processedAmount>{fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0002)}</ns2:processedAmount>
            <ns2:transactionID>{fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0001)}</ns2:transactionID>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)