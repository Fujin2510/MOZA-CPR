xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/exchange_rate_msb";
(:: import schema at "../Schemas/MSB.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/exchange_rate_obdx";
(:: import schema at "../Schemas/OBDX.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:ExchangeRateRequest) ::) {
    <ns2:ExchangeRateRequest>
        <ns2:user>{fn:data($Request/ns1:entity)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CCMB</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCMB_I_0001>{fn:data($Request/ns1:currency2)}</ns2:CCMB_I_0001>
            <ns2:CCMB_I_0002>{fn:substring(xs:string(current-dateTime()),1,19)}</ns2:CCMB_I_0002>
        </ns2:operationData>
    </ns2:ExchangeRateRequest>
};


local:func($Request)