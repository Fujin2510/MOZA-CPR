xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:CCCRResponse) ::) external;
declare variable $accountIdVar as xs:string external;
declare function local:func($Request as element() (:: schema-element(ns1:CCCRResponse) ::),$accountIdVar) as element() (:: schema-element(ns2:CPFCRequest) ::) {
    <ns2:CPFCRequest>
        <ns2:user>{fn:data($Request/ns1:user)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenceKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CPFC</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CPFC_I_0001>20</ns2:CPFC_I_0001>
            <ns2:CPFC_I_0002>{$accountIdVar}</ns2:CPFC_I_0002>
            <!--<ns2:CPFC_I_0003>{substring(replace(string(current-date()), '-', ''),1,8)}</ns2:CPFC_I_0003> -->
            <ns2:CPFC_I_0003>20240428</ns2:CPFC_I_0003>
            <ns2:CPFC_I_0004></ns2:CPFC_I_0004>
        </ns2:operationData>
    </ns2:CPFCRequest>
};

local:func($Request,$accountIdVar)