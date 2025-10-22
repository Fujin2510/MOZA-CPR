xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CCLE";
(:: import schema at "../Schema/CCLE.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCC_ACCOUNT_TXN_STMT";
(:: import schema at "../Schema/LEASE_ACCOUNT_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($userIdVar)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CCLE</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCLE_I_0001></ns2:CCLE_I_0001>
            <ns2:CCLE_I_0004>N</ns2:CCLE_I_0004>
            <ns2:CCLE_I_0005>S</ns2:CCLE_I_0005>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request, $userIdVar)