xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cdod";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/instruction_list";
(:: import schema at "../XSD/INSTRUCTION_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CDOD</ns2:transactionCode>
        <ns2:operationData>
       <ns2:CDOD_I_0001>     {
          let $acct := fn:data($Request/ns1:accountList)
         return
          if (contains($acct, "@~")) then
           substring-after($acct, "@~")
          else
           $acct
         }</ns2:CDOD_I_0001>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request)