xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/TD_DETAILS";
(:: import schema at "../Schema/TD_DETAILS%201.xsd" ::)

declare variable $userIdVar as xs:string external;

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;



declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:CAPDRequest) ::) {
    <ns2:CAPDRequest>
        <ns2:user>{$userIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenceKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CAPD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CAPD_I_0001>{fn:data($Request/ns1:accountId)}</ns2:CAPD_I_0001>
        </ns2:operationData>
    </ns2:CAPDRequest>
};

local:func($Request ,$userIdVar)