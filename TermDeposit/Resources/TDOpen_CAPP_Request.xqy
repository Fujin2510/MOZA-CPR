xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CAPP";
(:: import schema at "Schema/CAPP.xsd" ::)
declare namespace ns1="http://www.mozabank.org/TDOpen";
(:: import schema at "Schema/TD_OPEN.xsd" ::)

declare variable $TDOpen_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($TDOpen_Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:CAPPRequest) ::) {
    <ns2:CAPPRequest>
        <ns2:user>{fn:data($TDOpen_Request/ns1:partyId)}</ns2:user>
        <ns2:debitAccount>{fn:data($TDOpen_Request/ns1:accountId)}</ns2:debitAccount>
        <ns2:creditAccount>{if(fn:data($TDOpen_Request/ns1:payoutInstruction/ns1:accountId) != '') then  fn:data($TDOpen_Request/ns1:payoutInstruction/ns1:accountId)  else(fn:data($TDOpen_Request/ns1:accountId))}</ns2:creditAccount>
        <ns2:valueDate></ns2:valueDate> <!-- when the value date is current date then field should not have any value -->
        <ns2:productId>{fn:data($TDOpen_Request/ns1:productId)}</ns2:productId>
        <ns2:amount>{fn:data($TDOpen_Request/ns1:principalAmount/ns1:amount)}</ns2:amount>
    </ns2:CAPPRequest>
};

local:func($TDOpen_Request)