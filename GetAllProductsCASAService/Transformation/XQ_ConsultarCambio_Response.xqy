xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/exchange_rate_msb";
(:: import schema at "../Schemas/MSB_REQUEST.xsd" ::)
declare namespace ns1="http://www.mozabank.org/exchange_rate_obdx";
(:: import schema at "../Schemas/OBDX_REQUEST.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:transactionCode></ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCMB_O_0001></ns2:CCMB_O_0001>
            <ns2:CCMB_O_0002></ns2:CCMB_O_0002>
            <ns2:CCMB_O_0003>
                <ns2:CCMB_O_0003_0001></ns2:CCMB_O_0003_0001>
                <ns2:CCMB_O_0003_0002></ns2:CCMB_O_0003_0002>
                <ns2:CCMB_O_0003_0003></ns2:CCMB_O_0003_0003>
                <ns2:CCMB_O_0003_0004></ns2:CCMB_O_0003_0004>
                <ns2:CCMB_O_0003_0005>{fn:data($Response/ns1:data/ns1:exchangeRates/ns1:buyRate)}</ns2:CCMB_O_0003_0005>
                <ns2:CCMB_O_0003_0006>{fn:data($Response/ns1:data/ns1:exchangeRates/ns1:sellRate)}</ns2:CCMB_O_0003_0006>
            </ns2:CCMB_O_0003>
        </ns2:operationData>
        <ns2:channelOperationLogKey></ns2:channelOperationLogKey>
        <ns2:coreLogKey></ns2:coreLogKey>
        <ns2:coreCancelationCode></ns2:coreCancelationCode>
        <ns2:errorCode>{fn:data($Response/ns1:data/ns1:result/ns1:status)}</ns2:errorCode>
        <ns2:errorMessage>
            <ns2:messages></ns2:messages>
        </ns2:errorMessage>
        <ns2:layoutVersion></ns2:layoutVersion>
        <ns2:user></ns2:user>
        <ns2:password></ns2:password>
        <ns2:station></ns2:station>
        <ns2:licenceKey> </ns2:licenceKey>
        <ns2:encryption></ns2:encryption>
        <ns2:code></ns2:code>
        <ns2:version></ns2:version>
        <ns2:sessionId></ns2:sessionId>
        <ns2:language></ns2:language>
        <ns2:channelCode></ns2:channelCode>
        <ns2:origin></ns2:origin>
    </ns2:Response>
};

local:func($Response)