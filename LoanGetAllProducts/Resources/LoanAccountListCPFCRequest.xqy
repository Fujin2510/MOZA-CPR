xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/LOAN_ACCOUNT_LIST";
(:: import schema at "Schema/LOAN_ACCOUNT_LIST.xsd" ::)

declare variable $LoanAccountList as element() (:: schema-element(ns1:LOAN_ACCOUNT_LISTRequest) ::) external;
declare variable $CCCR-CCRD-Response as element() (:: schema-element(ns2:CCCRResponse) ::) external;
declare variable $ind as xs:string external;
declare function local:func($LoanAccountList as element() (:: schema-element(ns1:LOAN_ACCOUNT_LISTRequest) ::), 
                            $CCCR-CCRD-Response as element() (:: schema-element(ns2:CCCRResponse) ::),$ind) 
                            as element() (:: schema-element(ns3:CPFCRequest) ::) {
    <ns3:CPFCRequest>
        <ns3:user>{fn:data($LoanAccountList/ns1:partyId)}</ns3:user>
        <ns3:password></ns3:password>
        <ns3:origin>P</ns3:origin>
        <ns3:channelCode>INT</ns3:channelCode>
        <ns3:version>R30</ns3:version>
        <ns3:licenceKey>licenceKey</ns3:licenceKey>
        <ns3:sessionId>00000000</ns3:sessionId>
        <ns3:transactionCode>CPFC</ns3:transactionCode>
        <ns3:operationData>
            <ns3:CPFC_I_0001>20</ns3:CPFC_I_0001>
            <ns3:CPFC_I_0002>{fn:data($CCCR-CCRD-Response/ns2:operationData/ns2:CCCR_O_0003[$ind]/ns2:CCCR_O_0003_0001)}</ns3:CPFC_I_0002>
            <ns3:CPFC_I_0003>{fn:data($CCCR-CCRD-Response/ns2:operationData/ns2:CCCR_O_0003[$ind]/ns2:CCCR_O_0003_0003)}</ns3:CPFC_I_0003>
            <ns3:CPFC_I_0004></ns3:CPFC_I_0004>
        </ns3:operationData>
    </ns3:CPFCRequest>
};

local:func($LoanAccountList, $CCCR-CCRD-Response,$ind)