xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/ccar";
(:: import schema at "../DEBIT_CARD_LIST%201.xsd", 
                     "../CCAR1.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:DebitCardListRequest) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:DebitCardListRequest) ::)) as element() (:: schema-element(ns1:CCARRequest) ::) {
    <ns1:CCARRequest>
        <ns1:user>{fn:data($Request/ns1:dictionaryArray)}</ns1:user>
        <ns1:password>{fn:data($Request/ns1:referenceNo)}</ns1:password>
        <ns1:origin>{fn:data($Request/ns1:interfaceId)}</ns1:origin>
        <ns1:channelCode>{fn:data($Request/ns1:entity)}</ns1:channelCode>
        <ns1:licenceKey>{fn:data($Request/ns1:queryMap)}</ns1:licenceKey>
        <ns1:sessionId>{fn:data($Request/ns1:hostName)}</ns1:sessionId>
        <ns1:transactionCode>CCAR</ns1:transactionCode>
        <ns1:operationData>
            <ns1:CCAR_I_0001>{fn:data($Request/ns1:branchCode)}</ns1:CCAR_I_0001>
            <ns1:CCAR_I_0003>S</ns1:CCAR_I_0003>
            <ns1:CCAR_I_0004>N</ns1:CCAR_I_0004>
            <ns1:CCAR_I_0005>{fn:data($Request/ns1:accountId)}</ns1:CCAR_I_0005>
        </ns1:operationData>
    </ns1:CCARRequest>
};

local:func($Request)