xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns7="http://www.mozabanca.org/CDOD";
(:: import schema at "../../CASA/XSD/CDOD.xsd" ::) 
declare namespace ns1="http://www.mozabanca.org/casa-read";
(:: import schema at "../XSD/CASA_READ.xsd" ::) 

declare variable $CASARead as element() (:: schema-element(ns1:Request) ::) external;
declare variable $partyIdVar as xs:string  external;
declare variable $accountIdVar as xs:string  external;
declare function local:func($CASARead as element() (:: schema-element(ns1:Request) ::), 
                            $partyIdVar as xs:string, 
                            $accountIdVar as xs:string) 
                            as element() (:: schema-element(ns7:Request) ::) {
    <ns7:Request>
        <ns7:user>{$partyIdVar}</ns7:user>
        <ns7:password></ns7:password>
        <ns7:origin>P</ns7:origin>
        <ns7:channelCode>INT</ns7:channelCode>
        <ns7:version>R30</ns7:version>
        <ns7:licenceKey>licenceKey</ns7:licenceKey>
        <ns7:sessionId>00000000</ns7:sessionId>
        <ns7:transactionCode>CCDO</ns7:transactionCode>
        <ns7:operationData>
            <ns7:CCDO_I_0001>{if(fn:data($accountIdVar)) then $accountIdVar else ''}</ns7:CCDO_I_0001>
        </ns7:operationData>
    </ns7:Request>
};

local:func($CASARead,$partyIdVar ,$accountIdVar)