xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/branchCode";
(:: import schema at "../Schema/OBDXSchema/BRANCH_CODE.xsd" ::)
declare namespace ns2="http://www.mozabank.org/cdod";
(:: import schema at "../Schema/MSBSchema/CDOD.xsd" ::)

declare variable $Branch_Code_Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Branch_Code_Request as element() (:: schema-element(ns1:Request) ::),$userIdVar) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{$userIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CDOD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CDOD_I_0001>{fn:data($Branch_Code_Request/ns1:accountId)}</ns2:CDOD_I_0001> 
        </ns2:operationData>
    </ns2:Request>
};

local:func($Branch_Code_Request,$userIdVar)