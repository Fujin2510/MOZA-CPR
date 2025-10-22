xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/ExchangeRates";
(:: import schema at "ExchangeRatesGET.xsd" ::)
declare namespace ns2="http://xmlns.oracle.com/pcbpel/adapter/db/top/QueryExchangeRates";
(:: import schema at "QueryExchangeRates_table.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:QueryEXchangeRates) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:QueryEXchangeRates) ::)) as element() (:: schema-element(ns2:QueryExchangeRatesSelect_curr1InputParameters) ::) {
    <ns2:QueryExchangeRatesSelect_currency1_currency2_timestampInputParameters>
       <ns2:curr1>{fn:data($Request/ns1:currency1)}</ns2:curr1>  
        <!--  <ns2:curr2>{fn:data($Request/ns1:currency2)}</ns2:curr2>
      <ns2:mintimestamp>{fn:data($Request/ns1:TimeStamp)}</ns2:mintimestamp>  -->
    </ns2:QueryExchangeRatesSelect_currency1_currency2_timestampInputParameters>
};

local:func($Request)