xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/PaymentService.wsdl" ::)
declare namespace ns1="http://www.mozabank.org/POP_OBDX";
(:: import schema at "../Schema/POP.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:ProofOfPaymentBASE64) ::) {
    <ns2:ProofOfPaymentBASE64>
  <ns2:input> 
<nrOperacao>{ substring-after(fn:data($Request/ns1:id), '#') }</nrOperacao>
</ns2:input>
    </ns2:ProofOfPaymentBASE64>
};

local:func($Request)