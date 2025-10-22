xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CC_Payment";
(:: import schema at "../XSDs/CC_Payment.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/PAGC";
(:: import schema at "../XSDs/PAGC.xsd" ::)

declare variable $partyIdVar as xs:string external;
declare variable $CardNumber as xs:string external;
declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$partyIdVar,$CardNumber as xs:string) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{$partyIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>PAGC</ns2:transactionCode>
        <ns2:operationData>
            <ns2:PAGC_I_0001>{$CardNumber}</ns2:PAGC_I_0001>
            <ns2:PAGC_I_0002>  {
    xs:string(xs:integer(xs:decimal($OBDX_Request/ns1:amount/ns1:amount) * 100))
  }
            </ns2:PAGC_I_0002>
            <ns2:PAGC_I_0003>
              { substring-after(fn:data($OBDX_Request/ns1:debitAccountId), '@~') }
            </ns2:PAGC_I_0003>
            <ns2:PAGC_I_0004>{fn:data($OBDX_Request/ns1:cardNo)}</ns2:PAGC_I_0004>
        </ns2:operationData>
       
    </ns2:Request>
};

local:func($OBDX_Request ,$partyIdVar,$CardNumber)