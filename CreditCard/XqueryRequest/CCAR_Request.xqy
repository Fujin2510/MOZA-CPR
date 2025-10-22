xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CARDAC_PARTYLIST_SUMMARY";
(:: import schema at "../Schemas/CARDACCOUNT_PARTYLIST_SUMMARY.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCARDebitCard";
(:: import schema at "../Schemas/CCAR.xsd" ::)

declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($OBDX_Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CCAR</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCAR_I_0001>20</ns2:CCAR_I_0001>
            <ns2:CCAR_I_0003>S</ns2:CCAR_I_0003>
            <ns2:CCAR_I_0004>N</ns2:CCAR_I_0004>
            <ns2:CCAR_I_0007>N</ns2:CCAR_I_0007> 
        </ns2:operationData>
	<ns2:validation/>
    </ns2:Request>
};

local:func($OBDX_Request)