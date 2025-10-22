xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/LOANACCOUNT_PARTYLIST_SUMMARY";
(:: import schema at "Schema/LOANACCOUNT_PARTYLIST_SUMMARY.xsd" ::)

declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CCRD_Response as element() (:: schema-element(ns1:CCCRResponse) ::) external;

declare function local:func($CCRD_Response as element() (:: schema-element(ns1:CCCRResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    
     let $errCode := fn:data($CCRD_Response/*:errorCode) return
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
           <!-- <ns2:status> 
            {
              if (fn:data($CCRD_Response/ns1:errorCode) = '0') 
              then 'SUCCESS' 
              else 'FAILURE'
            }
            </ns2:status>
            {if(fn:data($CCRD_Response/ns1:errorCode) = '0') then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>) }-->
            
             <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($CCRD_Response/ns1:errorCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCRD_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCRD_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
			</ns2:errorList>)
                 else if($errCode = '906' or $errCode = 'A') then 
                (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
			</ns2:errorList>)
                 else(
			<ns2:errorList>
				<ns2:code>ERR001</ns2:code>
				<ns2:message>Invalid backend response</ns2:message>
			</ns2:errorList>)
			}
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        {
        for $ccdr in $CCRD_Response/ns1:operationData/ns1:CCCR_O_0003
        return
        <ns2:accounts> 
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId></ns2:partyId>
                <ns2:branchId>{fn:data($ccdr/ns1:CCRD/ns1:CCRD_O_0003)}</ns2:branchId>
                <ns2:accountId>{fn:data($ccdr/ns1:CCCR_O_0003_0001)}</ns2:accountId>
                <ns2:accountType>LOAN</ns2:accountType>
                <ns2:accountDisplayName>{fn:data($ccdr/ns1:CCCR_O_0003_0002)}</ns2:accountDisplayName>
                <ns2:currency>{fn:data($ccdr/ns1:CCCR_O_0003_0006)}</ns2:currency>
                <ns2:status>ACTIVE</ns2:status>
                <ns2:balance>
                    <ns2:currency>{fn:data($ccdr/ns1:CCCR_O_0003_0006)}</ns2:currency>
<ns2:amount>
  {
    fn-bea:format-number(
      xs:decimal(fn:data($ccdr/ns1:CCCR_O_0003_0005)) div 100,
      '0.00'
    )
  }
</ns2:amount>
                </ns2:balance>
                <ns2:interestType></ns2:interestType>
                <ns2:interestRate></ns2:interestRate>
                <ns2:openingDate>
                {let $date := fn:data($ccdr/ns1:CCRD/ns1:CCRD_O_0005)return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns2:openingDate>
                <ns2:relationshipType></ns2:relationshipType>
                <ns2:accountModule>LOAN</ns2:accountModule>
                <ns2:sortCode>{fn:data($ccdr/ns1:CCRD/ns1:CCRD_O_0003)}</ns2:sortCode>
                <ns2:relation></ns2:relation>
                <ns2:moduleType>CON</ns2:moduleType>
                <ns2:iban></ns2:iban> 
        </ns2:accounts>
        }
        <ns2:count></ns2:count>
        </ns2:data>
    </ns2:Response>
};

local:func($CCRD_Response)