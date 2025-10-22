xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/MAPP";
(:: import schema at "../Schemas/MAPP.xsd" ::)
declare namespace ns1="http://www.mozabank.org/td-fetch-penality";
(:: import schema at "../Schemas/TD_FETCH_PENALTY.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin></ns2:origin>
        <ns2:channelCode></ns2:channelCode>
        <ns2:version></ns2:version>
        <ns2:licenceKey></ns2:licenceKey>
        <ns2:sessionId></ns2:sessionId>
        <ns2:transactionCode></ns2:transactionCode>
        <ns2:operationData>
            <ns2:MAPP_I_0001></ns2:MAPP_I_0001>
            <ns2:MAPP_I_0002></ns2:MAPP_I_0002>
            <ns2:MAPP_I_0003></ns2:MAPP_I_0003>
            <ns2:MAPP_I_0004></ns2:MAPP_I_0004>
            <ns2:MAPP_I_0005></ns2:MAPP_I_0005>
        </ns2:operationData>
        <ns2:validation>
            <ns2:confirmationKey>
                <ns2:digitValues></ns2:digitValues>
                <ns2:digitPositions></ns2:digitPositions>
            </ns2:confirmationKey>
        </ns2:validation>
    </ns2:Request>
};

local:func($Request)