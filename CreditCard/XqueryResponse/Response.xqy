xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3="http://www.mozabank.org/CARDAC_PARTYLIST_SUMMARY";
(:: import schema at "../Schemas/CARDACCOUNT_PARTYLIST_SUMMARY.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCARCreditCard";
(:: import schema at "../../CreditCardGetAllProducts/Resources/XSD/CCAR.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCCACreditCard";
(:: import schema at "../Schemas/CCCA.xsd" ::)

declare variable $CCAR_Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CCCA_CDCA_Response as element() (:: schema-element(ns2:CCCAResponse) ::) external; 

declare function local:func($CCAR_Response as element() (:: schema-element(ns1:Response) ::), 
                            $CCCA_CDCA_Response as element() (:: schema-element(ns2:CCCAResponse) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
   <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>  {
                    if (fn:data($CCAR_Response/ns1:errorCode) = 0)
                    then 'SUCCESS'
                    else 'FAILURE'
                  }</ns3:status>
		 {if(fn:data($CCAR_Response/ns1:errorCode) = 0) then () else(
		 <ns2:errorList>
			 <ns2:code>ERR001</ns2:code>
			 <ns2:message>Invalid backend response</ns2:message>
		  </ns2:errorList>)  }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            <ns3:accounts>
                <ns3:account>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:partyId>{fn:data($CCCA_CDCA_Response/ns2:user)}</ns3:partyId>
                    <ns3:branchId>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0003)}</ns3:branchId>
                    <ns3:accountId>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0001)}</ns3:accountId>
                    <ns3:accountType>CCA</ns3:accountType>
                    <ns3:accountDisplayName>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0002)}</ns3:accountDisplayName>
                    <ns3:currency>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0008)}</ns3:currency>
                    <ns3:status>     {
                        if (fn:data($CCAR_Response/ns1:operationData/ns1:CCAR_O_0003/ns1:CCAR_O_0003_0011) = 'NORMAL')
                        then 'ACTIVE'
                        else 'INACTIVE'
                      }
                  </ns3:status>
                    <ns3:balance>
                        <ns3:currency>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0008)}</ns3:currency>
                        <ns3:amount>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0004)}</ns3:amount>
                    </ns3:balance>
                    <ns3:interestType></ns3:interestType>
                    <ns3:interestRate></ns3:interestRate>
                     <ns3:openingDate>{let $date := fn:data($CCAR_Response/ns1:operationData/ns1:CCAR_O_0003[ns1:CCAR_O_0003_0013 = 'CARC']/ns1:CCAR_O_0003_0007) return 
                        concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}</ns3:openingDate>
                    <ns3:relationshipType></ns3:relationshipType>
                    <ns3:accountModule>CON</ns3:accountModule>
                    <ns3:sortCode></ns3:sortCode>
                    <ns3:relation></ns3:relation>
                    <ns3:moduleType></ns3:moduleType>
                    <ns3:iban></ns3:iban>
                </ns3:account>
            </ns3:accounts>
            <ns3:count></ns3:count>
        </ns3:data>
    </ns3:Response>
};

local:func($CCAR_Response, $CCCA_CDCA_Response)