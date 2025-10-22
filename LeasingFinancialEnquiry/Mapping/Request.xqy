xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CPFL";
(:: import schema at "../XSDs/CPFL.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/LSI";
(:: import schema at "../XSDs/LEASE_SCHEDULE_INQUIRY.xsd" ::)
declare variable $partyIdVar as xs:string external;

declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$partyIdVar as xs:string) as element() (:: schema-element(ns2:Request) ::) {
       <ns2:Request>
        <ns2:user>{$partyIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CPFL</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CPFL_I_0001>20</ns2:CPFL_I_0001>
            <ns2:CPFL_I_0002>{fn:data($OBDX_Request/ns1:account)}</ns2:CPFL_I_0002>
            <ns2:CPFL_I_0003>{replace(fn:data($OBDX_Request/ns1:fromDate), '-', '')}</ns2:CPFL_I_0003>
<ns2:CPFL_I_0004>{
  let $val := fn:normalize-space(fn:data($OBDX_Request/ns1:type))
  return
    if ($val != "") then $val else " "
}</ns2:CPFL_I_0004>
            <ns2:CPFL_I_0005>{replace(fn:data($OBDX_Request/ns1:toDate), '-', '')}</ns2:CPFL_I_0005>
        </ns2:operationData>
    </ns2:Request>
};

local:func($OBDX_Request ,$partyIdVar)