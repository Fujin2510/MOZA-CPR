xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns1="http://www.mozabank.org/LOAN_ACCOUNT_LIST";
(:: import schema at "Schema/LOAN_ACCOUNT_LIST.xsd" ::)

declare variable $Request-CPFC as element() (:: schema-element(ns1:LOAN_ACCOUNT_LISTRequest) ::) external;

declare function local:func($Request-CPFC as element() (:: schema-element(ns1:LOAN_ACCOUNT_LISTRequest) ::)) as element() (:: schema-element(ns2:CPFCRequest) ::) {
    <ns2:CPFCRequest>
        <ns2:user>{fn:data($Request-CPFC/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenceKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CPFC</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CPFC_I_0001>20</ns2:CPFC_I_0001>
            <ns2:CPFC_I_0002></ns2:CPFC_I_0002>
            <ns2:CPFC_I_0003></ns2:CPFC_I_0003>
            <ns2:CPFC_I_0004></ns2:CPFC_I_0004>
        </ns2:operationData>
    </ns2:CPFCRequest>
};

local:func($Request-CPFC)