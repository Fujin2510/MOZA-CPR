xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CGER";
(:: import schema at "../XSD/CGER.xsd" ::)
declare namespace ns3="http://www.mozabanca.org/casa-read";
(:: import schema at "../XSD/CASA_READ.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/cdod";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CCDO_Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CGER_Response as element() (:: schema-element(ns2:Response) ::) external;
declare variable $value as xs:string external;
declare variable $userIdVariable as xs:string external;
declare variable $bookBalance as xs:string external;

declare function local:func($CCDO_Response as element() (:: schema-element(ns1:Response) ::), 
                            $CGER_Response as element() (:: schema-element(ns2:Response) ::),$value,$userIdVariable,$bookBalance) 
                            as element() (:: schema-element(ns3:Response) ::) {
                            
                     let $errCode := fn:data($CCDO_Response/*:errorCode) return                                     

     <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
              <ns3:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns3:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                   else if(fn:data($CCDO_Response/ns1:errorCode) = 'C') then 
                 (
			<ns3:errorList>
				<ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCDO_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',substring-before(xs:string(fn:data($CCDO_Response/*:errorMessage/*:messages[1])),'-')) }</ns3:code>
				<ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCDO_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',substring-after(xs:string(fn:data($CCDO_Response/*:errorMessage/*:messages[1])),'-')) }</ns3:message>
			</ns3:errorList>)
                 else if($errCode = '906' or $errCode = 'A') then 
                (
			<ns3:errorList>
				<ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns3:code>
				<ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns3:message>
			</ns3:errorList>)
                 else(
			<ns3:errorList>
				<ns3:code>ERR001</ns3:code>
				<ns3:message>Invalid backend response</ns3:message>
			</ns3:errorList>)
			}
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
           {
  if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 
            
            <ns3:account>
                <ns3:dictionaryArray>
                    <ns3:nameValuePairArray>
                        <ns3:name>SwiftCode</ns3:name>
                        <ns3:value>BMOCMZMA</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.SwiftCode</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>
                    
                        <ns3:nameValuePairArray>
                        <ns3:name>AccountManager</ns3:name>
                        <ns3:value>{fn:data($CGER_Response/ns2:operationData/ns2:CGER_O_0001)}</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.AccountManager</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>
                    
                        <ns3:nameValuePairArray>
                        <ns3:name>AccountManagerEmailId</ns3:name>
                        <ns3:value>{fn:data($CGER_Response/ns2:operationData/ns2:CGER_O_0002)}</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.AccountManagerEmailId</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>
                    
                        <ns3:nameValuePairArray>
                        <ns3:name>Nib</ns3:name>
                        <ns3:value>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0025)}</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.Nib</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>
                    
                        <ns3:nameValuePairArray>
                        <ns3:name>Nuib</ns3:name>
                        <ns3:value>{$value}</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.Nuib</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>

                    <ns3:nameValuePairArray>
                        <ns3:name>AccountId</ns3:name>
                        <ns3:value>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0001)}</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.AccountId</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>

                   <ns3:nameValuePairArray>
                        <ns3:name>CreditHold</ns3:name>
                        <ns3:value>
{
                          let $raw := xs:string(fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0010))
                          let $len := string-length($raw)
                          let $intPart := substring($raw, 1, $len - 2)
                          let $fracPart := substring($raw, $len - 1)
                          return xs:decimal(concat($intPart, ".", $fracPart))
                        }
</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.CreditHold</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>

                    <ns3:nameValuePairArray>
                        <ns3:name>DebitHold</ns3:name>
                        <ns3:value>
{
                          let $raw := xs:string(fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0009))
                          let $len := string-length($raw)
                          let $intPart := substring($raw, 1, $len - 2)
                          let $fracPart := substring($raw, $len - 1)
                          return xs:decimal(concat($intPart, ".", $fracPart))
                        }
</ns3:value>
                        <ns3:genericName>com.finonyx.digx.cz.domain.dda.entity.CZDemandDepositAccount.DebitHold</ns3:genericName>
                        <ns3:datatype>java.lang.String</ns3:datatype>
                    </ns3:nameValuePairArray>


                </ns3:dictionaryArray>


<ns3:partyId>
  {
    let $u := fn:string($CCDO_Response/ns1:user)
    return if ($u = '' or $u = 'null')
           then ()
           else $u
  }
</ns3:partyId>
                <ns3:branchId>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0003)}</ns3:branchId>
                <ns3:accountId>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0001)}</ns3:accountId>
                <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:availableBalance>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
   <ns3:amount>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0007),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:amount>
</ns3:availableBalance>
                <ns3:averageBalance>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
               
                    <ns3:amount>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0013),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:amount>
                </ns3:averageBalance>
                <ns3:interestType></ns3:interestType>
                <ns3:interestRate></ns3:interestRate>
                <ns3:openingDate></ns3:openingDate>
                <ns3:module>CON</ns3:module>
                <ns3:accountDisplayName>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0002)}</ns3:accountDisplayName>
                <ns3:currentBalance>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
                
                       <ns3:amount>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_00081),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:amount>
                </ns3:currentBalance>
                <ns3:productId>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0002)}</ns3:productId>
                <ns3:accountType>CURRENT</ns3:accountType>
                <ns3:holdingPattern>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0021)}</ns3:holdingPattern>
                <ns3:hasSweepOutInstruction>false</ns3:hasSweepOutInstruction>
                <ns3:averageQuarterlyBalance></ns3:averageQuarterlyBalance>
                <ns3:averageMonthlyBalance></ns3:averageMonthlyBalance>
                <ns3:lienAmount>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
                    <ns3:amount>0.00</ns3:amount>
                </ns3:lienAmount>
                <ns3:sweepInAmount>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
                    <ns3:amount>0.00</ns3:amount>
                </ns3:sweepInAmount>
                <ns3:unclearFund>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
              
                  
                      <ns3:amount>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0010),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:amount>
                  </ns3:unclearFund>
                <ns3:fundsAdvanceLimit>
                    <ns3:currency>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0015)}</ns3:currency>
                    <ns3:amount>0.00</ns3:amount>
                </ns3:fundsAdvanceLimit>
                <ns3:hasChequeBookFacility>false</ns3:hasChequeBookFacility>
                <ns3:accountStatusCode>E</ns3:accountStatusCode>
         
                   
                      <ns3:minBalance>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0012),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:minBalance>
             
                      <ns3:bookBalance>{$bookBalance}</ns3:bookBalance>
                <ns3:customerShortName>{$userIdVariable}</ns3:customerShortName>
                <ns3:idCustomer>{$userIdVariable}</ns3:idCustomer>
                <ns3:nbrBranch></ns3:nbrBranch>
                <ns3:nbrAccount></ns3:nbrAccount>
                <ns3:sortCode></ns3:sortCode>
                <ns3:modeOfOperation></ns3:modeOfOperation>
          
                  
                      <ns3:balance>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0007),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:balance>
                <ns3:acctType></ns3:acctType>
                <ns3:ccyDesc></ns3:ccyDesc>
                <ns3:descAcctType>U</ns3:descAcctType>
                <ns3:relation></ns3:relation>
                <ns3:overdraftUsageLimit>{  xs:decimal(fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0011))}</ns3:overdraftUsageLimit>
                <ns3:hasSweepOutFacility>false</ns3:hasSweepOutFacility>
                <ns3:hasSweepInFacility>false</ns3:hasSweepInFacility>
                <ns3:hasSIFacility>false</ns3:hasSIFacility>
               <ns3:hasOverdraftFacility>{
               if (xs:decimal(fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0011)) gt 0)
              then true()        (: xs:boolean true :)
                 else false()       (: xs:boolean false :)
                }</ns3:hasOverdraftFacility>
                <ns3:unclearFunds>{xs:decimal(fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0010))}</ns3:unclearFunds>
                <ns3:productCode>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0002)}</ns3:productCode>
                <ns3:productName></ns3:productName>
             
                   <ns3:holdAmount>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0009),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:holdAmount>
                
                <ns3:dailyWithdrawalLimit></ns3:dailyWithdrawalLimit>               
            
                               <ns3:netBalance>{
  let $v := translate(normalize-space($CCDO_Response/ns1:operationData/ns1:CDOD_O_0007),'.','')
  return concat(substring($v,1,string-length($v)-2),'.',substring($v,string-length($v)-1))
}</ns3:netBalance>
                <ns3:accountModule>N</ns3:accountModule>
                <ns3:isLMEnabled>false</ns3:isLMEnabled>
                <ns3:partyAccountRelationship></ns3:partyAccountRelationship>
                <ns3:hostRelationshipCode></ns3:hostRelationshipCode>
                <ns3:iban>{fn:data($CCDO_Response/ns1:operationData/ns1:CDOD_O_0026)}</ns3:iban>
                <ns3:noOfDebitCards></ns3:noOfDebitCards>
                <ns3:atmEnabled>false</ns3:atmEnabled>
                <ns3:isNomineeRegistered>false</ns3:isNomineeRegistered>
            </ns3:account>
             else()
}
        </ns3:data>
    </ns3:Response>
};

local:func($CCDO_Response, $CGER_Response,$value,$userIdVariable,$bookBalance)