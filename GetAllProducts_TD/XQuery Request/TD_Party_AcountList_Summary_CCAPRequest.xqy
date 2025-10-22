xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccap_tdaccount_partylist_summary";
(:: import schema at "../Schema/TDACCOUNT_PARTYLIST_SUMMARY.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenceKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CCAP</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCAP_I_0001>99</ns2:CCAP_I_0001> 
            <ns2:CCAP_I_0004>N</ns2:CCAP_I_0004>
            <ns2:CCAP_I_0005>N</ns2:CCAP_I_0005>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request)