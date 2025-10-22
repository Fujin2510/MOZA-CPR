xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/casa-read";
(:: import schema at "../XSD/CASA_READ.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/cmov";
(:: import schema at "../XSD/CMOV.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVariable as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVariable) as element() (:: schema-element(ns2:CMOVRequest) ::) {
    <ns2:CMOVRequest>
        <ns2:user>{$userIdVariable}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CMOV</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CMOV_I_0001>{fn:data($Request/ns1:accountId)}</ns2:CMOV_I_0001>
            <ns2:CMOV_I_0002>1</ns2:CMOV_I_0002>
            <ns2:CMOV_I_0003></ns2:CMOV_I_0003>
            <ns2:CMOV_I_0004>ALL</ns2:CMOV_I_0004>
            <ns2:CMOV_I_0005>00000000</ns2:CMOV_I_0005>
            <ns2:CMOV_I_0006>99999999</ns2:CMOV_I_0006>
            <ns2:CMOV_I_0007>  {
              let $yesterday := fn:current-date() - xs:dayTimeDuration('P1D')
              return fn:concat(
                       fn:substring(fn:string($yesterday), 1, 4),  (: Year :)
                       fn:substring(fn:string($yesterday), 6, 2),  (: Month :)
                       fn:substring(fn:string($yesterday), 9, 2)   (: Day :)
                     )
            }</ns2:CMOV_I_0007>
            <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
            <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
        </ns2:operationData>
    </ns2:CMOVRequest>
};

local:func($Request,$userIdVariable)