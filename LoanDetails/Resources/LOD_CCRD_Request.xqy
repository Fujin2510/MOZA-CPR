xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CreditAccountDetails";
(:: import schema at "CCRD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/LoanOutstandingDetails";
(:: import schema at "LOAN_OUTSTANDING_DETAILS.xsd" ::)

declare variable $LOD_Request as element() (:: schema-element(ns1:LOAN_OUTSTANDING_DETAILSRequest) ::) external;

declare function local:func($LOD_Request as element() (:: schema-element(ns1:LOAN_OUTSTANDING_DETAILSRequest) ::)) as element() (:: schema-element(ns2:CreditAccountDetailsRequest) ::) {
    <ns2:CreditAccountDetailsRequest>
        <ns2:user>{fn:data($LOD_Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>28f2f5ee</ns2:sessionId>
        <ns2:transactionCode>CCRD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCRD_I_0001>{fn:data($LOD_Request/ns1:loanAccountId)}</ns2:CCRD_I_0001>
        </ns2:operationData>
    </ns2:CreditAccountDetailsRequest>
};

local:func($LOD_Request)