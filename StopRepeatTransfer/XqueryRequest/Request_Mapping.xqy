xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CANCEL_INSTRUCTION";
(:: import schema at "../XSD/CANCEL_INSTRUCTION.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/COTF";
(:: import schema at "../XSD/COTF.xsd" ::)
declare variable $partyIdVar as xs:string external;

declare variable $OBDX_request as element() (:: schema-element(ns1:CANCEL_INSTRUCTION_Request) ::) external;

declare function local:func($OBDX_request as element() (:: schema-element(ns1:CANCEL_INSTRUCTION_Request) ::),$partyIdVar as xs:string) as element() (:: schema-element(ns2:COTF_Request) ::) {
    <ns2:COTF_Request>
        <ns2:user>{$partyIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>COTF</ns2:transactionCode>
        <ns2:operationData>
            <ns2:COTF_I_0001>{fn:data($OBDX_request/ns1:contractReferenceId)}</ns2:COTF_I_0001>
        </ns2:operationData>
    </ns2:COTF_Request>
};

local:func($OBDX_request ,$partyIdVar)