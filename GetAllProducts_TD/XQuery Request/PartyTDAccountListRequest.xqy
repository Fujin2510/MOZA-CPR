xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns4="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccap_party_td_accounts_list";
(:: import schema at "../Schema/PARTY_TD_ACCOUNTS_LIST.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_td_product_details";
(:: import schema at "../Schema/TD_PRODUCT_DETAILS.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_tdlist";
(:: import schema at "../Schema/TD_LIST.xsd" ::)

declare variable $RequestTDAccPartyListSummary as element() (:: schema-element(ns1:Request) ::) external;
declare variable $RequestTDList as element() (:: schema-element(ns2:Request) ::) external;
declare variable $RequestTDProductDetails as element() (:: schema-element(ns3:Request) ::) external;
declare variable $RequestPartyTDAccList as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($RequestTDAccPartyListSummary as element() (:: schema-element(ns1:Request) ::), 
                            $RequestTDList as element() (:: schema-element(ns2:Request) ::) (:: schema-element(ns3:Request) ::), 
                            $RequestPartyTDAccList as element() (:: schema-element(ns1:Request) ::)) 
                            as element() (:: schema-element(ns4:CAPDRequest) ::) {
    <ns4:CAPDRequest>
        <ns4:user>{fn:data($RequestPartyTDAccList/ns1:partyId)}</ns4:user>
        <ns4:password></ns4:password>
        <ns4:origin>P</ns4:origin>
        <ns4:channelCode>INT</ns4:channelCode>
        <ns4:version>R30</ns4:version>
        <ns4:licenceKey>licenceKey</ns4:licenceKey>
        <ns4:sessionId>00000000</ns4:sessionId>
        <ns4:transactionCode>CAPD</ns4:transactionCode>
        <ns4:operationData>
            <ns4:CAPD_I_0001></ns4:CAPD_I_0001>
        </ns4:operationData>
    </ns4:CAPDRequest>
};

local:func($RequestTDAccPartyListSummary, $RequestTDList, $RequestPartyTDAccList)