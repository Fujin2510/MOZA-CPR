xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CC_CASH_ADVANCE";
(:: import schema at "../XSDs/CC_CASH_ADVANCE.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/CHAD";
(:: import schema at "../XSDs/CHAD.xsd" ::)
declare variable $partyIdVar as xs:string external;


declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$partyIdVar as xs:string) as element() (:: schema-element(ns2:Request) ::) {

    <ns2:Request>
        <ns2:user>{$partyIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CHAD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CHAD_I_0001>{fn:data($OBDX_Request/ns1:id)}</ns2:CHAD_I_0001>
<ns2:CHAD_I_0002>{concat(fn:data($OBDX_Request/ns1:amount/ns1:amount), '00')}</ns2:CHAD_I_0002>
            <ns2:CHAD_I_0003>{fn:data($OBDX_Request/ns1:cardDescription)}</ns2:CHAD_I_0003>
            <ns2:CHAD_I_0004>{fn:data($OBDX_Request/ns1:accountDescription)}</ns2:CHAD_I_0004>
            
        </ns2:operationData>
       
    </ns2:Request>
};

local:func($OBDX_Request ,$partyIdVar)