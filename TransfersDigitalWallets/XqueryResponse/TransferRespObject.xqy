xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/DW_TFCM_TRANSFER";
(:: import schema at "../XSD/dw_tfcm_transfer.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:performSingleTransferResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:performSingleTransferResponse) ::)) as element() (:: schema-element(ns2:transfers) ::) {
    <ns2:transfers>
        <ns2:amount>{fn:data($Response/ns1:response/amount)}</ns2:amount>
        <ns2:beneMobNumber>{fn:data($Response/ns1:response/cellular)}</ns2:beneMobNumber>
        <ns2:currency>{fn:data($Response/ns1:response/currency)}</ns2:currency>
       <ns2:date>
  {
    replace(fn:data($Response/ns1:response/status/executado), " ", "T")
  }
</ns2:date>
        <ns2:transactionID>{fn:data($Response/ns1:response/transactionID)}</ns2:transactionID>
    </ns2:transfers>
};

local:func($Response)