xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CGER";
(:: import schema at "../XSD/CGER.xsd" ::)

declare variable $userIdVariable as xs:string external;

declare function local:func($userIdVariable as xs:string) as element() (:: schema-element(ns1:Request) ::) {    
<ns1:Request>
        <ns1:user>{$userIdVariable}</ns1:user>
        <ns1:password></ns1:password>
        <ns1:origin>P</ns1:origin>
        <ns1:channelCode>INT</ns1:channelCode>
        <ns1:version>R30</ns1:version>
        <ns1:licenceKey>licenseKey</ns1:licenceKey>
        <ns1:sessionId>00000000</ns1:sessionId>
        <ns1:transactionCode>CGER</ns1:transactionCode>
        <ns1:operationData></ns1:operationData>
    </ns1:Request>
};

local:func($userIdVariable)