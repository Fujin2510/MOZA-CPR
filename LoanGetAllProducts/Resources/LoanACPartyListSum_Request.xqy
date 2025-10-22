xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/LOANACCOUNT_PARTYLIST_SUMMARY";
(:: import schema at "Schema/LOANACCOUNT_PARTYLIST_SUMMARY.xsd" ::)

declare variable $LoanACPartyListSum_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($LoanACPartyListSum_Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:CCCRRequest) ::) {
    <ns2:CCCRRequest>
        <ns2:user>{fn:data($LoanACPartyListSum_Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenseKey>licenseKey</ns2:licenseKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CCCR</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCCR_I_0001>20</ns2:CCCR_I_0001>
            <ns2:CCCR_I_0004>S</ns2:CCCR_I_0004>
            <ns2:CCCR_I_0005>S</ns2:CCCR_I_0005>
        </ns2:operationData>
    </ns2:CCCRRequest>
};

local:func($LoanACPartyListSum_Request)