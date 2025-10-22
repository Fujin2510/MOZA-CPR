xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/exchange_rate_msb";
(:: import schema at "../Schemas/MSB_REQUEST.xsd" ::)
declare namespace ns1="http://www.mozabank.org/exchange_rate_obdx";
(:: import schema at "../Schemas/OBDX_REQUEST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user></ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin></ns2:origin>
        <ns2:channelCode> </ns2:channelCode>
        <ns2:version></ns2:version>
        <ns2:licenceKey></ns2:licenceKey>
        <ns2:sessionId></ns2:sessionId>
        <ns2:transactionCode>{fn:data($Request/ns1:interfaceId)}</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCMB_I_0001>{fn:data($Request/ns1:currency1)}</ns2:CCMB_I_0001>
            <ns2:CCMB_I_0002>{fn:replace(fn:substring(fn:string(fn:current-date()), 1, 10), "-", "")}</ns2:CCMB_I_0002>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request)