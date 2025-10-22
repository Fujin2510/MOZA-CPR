xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/ccPayChangeOption";
(:: import schema at "../Schema/CC_PAY_CHANGE_OPTION.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/APAG";
(:: import schema at "../Schema/APAG.xsd" ::)
declare variable $partyIdVar as xs:string external;
declare variable $CardNumber as xs:string external;

declare variable $CC_Pay_Change_Option_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($CC_Pay_Change_Option_Request as element() 
(:: schema-element(ns1:Request) ::),$partyIdVar,$CardNumber as xs:string)  as element() (:: schema-element(ns2:Request) ::) {

    <ns2:Request>
        <ns2:user>{$partyIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>APAG</ns2:transactionCode>
        <ns2:operationData>
            <ns2:APAG_I_0001>{$CardNumber}</ns2:APAG_I_0001>
            <ns2:APAG_I_0002>{fn:data($CC_Pay_Change_Option_Request/ns1:paymentType)}</ns2:APAG_I_0002>
<ns2:APAG_I_0003>
  {substring-before(fn:data($CC_Pay_Change_Option_Request/ns1:paymentOption), "%")}
</ns2:APAG_I_0003>
</ns2:operationData>
        <ns2:validation>
            <ns2:confirmationKey>
                <ns2:digitValues></ns2:digitValues>
                <ns2:digitPositions></ns2:digitPositions>
            </ns2:confirmationKey>
        </ns2:validation>
    </ns2:Request>
};

local:func($CC_Pay_Change_Option_Request,$partyIdVar ,$CardNumber)