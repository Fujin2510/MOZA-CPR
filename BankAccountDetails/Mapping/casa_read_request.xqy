xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/casa-read";
(:: import schema at "../XSD/CASA_READ.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/cdod";
(:: import schema at "../XSD/CDOD.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVariable as xs:string external;


declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVariable) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{$userIdVariable}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CDOD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CDOD_I_0001>{fn:data($Request/ns1:accountId)}</ns2:CDOD_I_0001>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request, $userIdVariable)