xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/SELF_FX_CCY_TRANSFER";
(:: import schema at "../Schema/SELF_FX_CCY_TRANSFER.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/tfcd";
(:: import schema at "../Schema/TFCD.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:SELF_FX_CCY_TRANSFER_Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:SELF_FX_CCY_TRANSFER_Request) ::), $userIdVar as xs:string) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($userIdVar)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>TFCD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:TFCD_I_0001>
  {
    let $acct := fn:data($Request/ns1:debitAccount)
    return
      if (contains($acct, "@~")) then
        substring-after($acct, "@~")
      else
        $acct
  }
</ns2:TFCD_I_0001>

<ns2:TFCD_I_0002>
  {
    let $acct := fn:data($Request/ns1:creditAccount)
    return
      if (contains($acct, "@~")) then
        substring-after($acct, "@~")
      else
        $acct
  }
</ns2:TFCD_I_0002>

<ns2:TFCD_I_0003>
  {
    xs:string(xs:integer(xs:decimal($Request/ns1:amount/ns1:amount) * 100))
  }
</ns2:TFCD_I_0003>

                      <ns2:TFCD_I_0004>{fn:data($Request/ns1:amount/ns1:currency)}</ns2:TFCD_I_0004>
            <ns2:TFCD_I_0005>{fn:data($Request/ns1:confirmationStatus)}</ns2:TFCD_I_0005>


        </ns2:operationData>
    </ns2:Request>
};

local:func($Request, $userIdVar)