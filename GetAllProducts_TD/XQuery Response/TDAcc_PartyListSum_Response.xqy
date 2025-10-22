xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_tdaccount_partylist_summary";
(:: import schema at "../Schema/TDACCOUNT_PARTYLIST_SUMMARY.xsd" ::)

declare variable $CCAP_Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CAPD_Response as element() (:: schema-element(ns2:CAPDResponse) ::) external;

declare variable $account as element(ns3:accounts):=
            <ns3:accounts>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCAP_Response/ns1:user)}</ns3:partyId>
                <ns3:branchId>{substring(fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0001),1,3)}</ns3:branchId>
                <ns3:accountId>{fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0001)}</ns3:accountId>
                <ns3:accountType>TRD</ns3:accountType>
                <ns3:accountDisplayName>{fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0002)}</ns3:accountDisplayName>
                <ns3:currency>{fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0006)}</ns3:currency>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:balance>
                    <ns3:currency>{fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0006)}</ns3:currency>
                                        <ns3:amount>{
                      if ($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0006) then
                        fn-bea:format-number(
                          xs:decimal(fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0005)) div 100,
                          '0.00'
                        )
                      else ()
                    }</ns3:amount>
                </ns3:balance>
                <ns3:interestType></ns3:interestType>
                <ns3:interestRate></ns3:interestRate>
                <ns3:openingDate>
                {let $date := fn:data($CAPD_Response/ns2:operationData/ns2:CAPD_O_0005) return 
                if(fn:data($CAPD_Response/ns2:operationData/ns2:CAPD_O_0005) != '') then
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00') else()}
                </ns3:openingDate>
                <ns3:relationshipType></ns3:relationshipType>
                <ns3:accountModule>CON</ns3:accountModule>
                <ns3:sortCode>{substring(fn:data($CCAP_Response/ns1:operationData/ns1:CCAP_O_0003/ns1:CCAP_O_0003_0001),1,3)}</ns3:sortCode> <!-- branch code to be fetched from request-->
                <ns3:relation></ns3:relation>
                <ns3:moduleType></ns3:moduleType>
                <ns3:iban></ns3:iban>
            </ns3:accounts>;

declare function local:func($CCAP_Response as element() (:: schema-element(ns1:Response) ::), 
                            $CAPD_Response as element() (:: schema-element(ns2:CAPDResponse) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>
                {
                  if (fn:data($CCAP_Response/ns1:errorCode) = 0) 
                  then 'SUCCESS' 
                  else 'FAILURE'
                }
                </ns3:status>
                    {if(fn:data($CCAP_Response/ns1:errorCode) = 0) then () else(
                <ns2:errorList>
                    <ns2:code>ERR001</ns2:code>
                    <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>) } 
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            { $account }
            
            <ns3:count>{count($account)}</ns3:count>
        </ns3:data>
    </ns3:Response>
};

local:func($CCAP_Response, $CAPD_Response)