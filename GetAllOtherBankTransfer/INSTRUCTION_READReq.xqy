xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/obdx/CTFO";
(:: import schema at "CTFO.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/INSTRUCTION_READ";
(:: import schema at "INSTRUCTION_READ.xsd" ::)

declare variable $userIdVar as xs:string external;
declare variable $accountID as xs:string external;
declare variable $INSTRUCTION_READ as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($userIdVar as xs:string, 
                            $accountID as xs:string, 
                            $INSTRUCTION_READ as element() (:: schema-element(ns1:Request) ::)) 
                            as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($userIdVar)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>4fe42a2e</ns2:sessionId>
        <ns2:transactionCode>CTFO</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CTFO_I_0001>{
            
if (contains($accountID, "@~")) then
        substring-after($accountID, "@~")
      else
        $accountID
            }</ns2:CTFO_I_0001>
            <ns2:CTFO_I_0002>5</ns2:CTFO_I_0002>
           
            <ns2:CTFO_I_0004>20250613</ns2:CTFO_I_0004>
            <ns2:CTFO_I_0007>20250613</ns2:CTFO_I_0007>
            <ns2:CTFO_I_0008>20251213</ns2:CTFO_I_0008>
            <ns2:CTFO_I_0005>{' '}</ns2:CTFO_I_0005>
            <ns2:CTFO_I_0006>A</ns2:CTFO_I_0006>
        </ns2:operationData>
    </ns2:Request>
};

local:func($userIdVar, $accountID, $INSTRUCTION_READ)