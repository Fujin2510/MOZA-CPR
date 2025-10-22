xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/ExchangeRates";
(:: import schema at "ExchangeRatesGET.xsd" ::)
declare namespace ns1="http://xmlns.oracle.com/pcbpel/adapter/db/top/QueryExchangeRates";
(:: import schema at "QueryExchangeRates_table.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:XchgRateCachedResultCollection) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:XchgRateCachedResultCollection) ::)) as element() (:: schema-element(ns2:QueryResponse) ::) {
    <ns2:QueryResponse>
        <ns2:Response>{fn:data($Response/ns1:XchgRateCachedResult/ns1:exchangeRatesResponse)}</ns2:Response>
    </ns2:QueryResponse>
};

local:func($Response)