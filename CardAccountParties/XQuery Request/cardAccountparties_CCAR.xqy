xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/card_account_parties";
(:: import schema at "../XSD/card_account.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCARDebitCard";
(:: import schema at "../XSD/CCAR.xsd" ::)

declare variable $request_cardAccountParties as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string  external;
declare function local:func($request_cardAccountParties as element() (:: schema-element(ns1:Request) ::),$userIdVar) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{$userIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenceKey</ns2:licenceKey>
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

local:func($request_cardAccountParties,$userIdVar)