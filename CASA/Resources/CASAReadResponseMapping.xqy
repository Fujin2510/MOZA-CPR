xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CDOD-MSB";
(:: import schema at "../XSD/CDOD-MSB.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CASARead";
(:: import schema at "../XSD/CASA_READ.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
   let $errCode := xs:string(fn:data($Response/*:errorCode)) return
    <ns2:Response>
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($errCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-')) }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',substring-after(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-')) }</ns2:message>
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
        if( $errCode = '0') then 
        <ns2:account>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:partyId>{fn:data($Response/ns1:user)}</ns2:partyId>
            <ns2:branchId>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0003)}</ns2:branchId>
            <ns2:accountId>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0001)}</ns2:accountId>
            <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
            <ns2:status>ACTIVE</ns2:status>
            <ns2:availableBalance>
                <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
                <ns2:amount>
{
                  let $raw := xs:string(fn:data($Response/ns1:operationData/ns1:CDOD_O_0007))
                  let $len := string-length($raw)
                  let $intPart := substring($raw, 1, $len - 2)
                  let $fracPart := substring($raw, $len - 1)
                  return xs:decimal(concat($intPart, ".", $fracPart))
                }
</ns2:amount>
            </ns2:availableBalance>
            <ns2:averageBalance>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:averageBalance>
            <ns2:interestType></ns2:interestType>
            <ns2:interestRate></ns2:interestRate>
            <ns2:openingDate></ns2:openingDate>
            <ns2:module>CON</ns2:module>
            <ns2:accountDisplayName>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0002)}</ns2:accountDisplayName>
            <ns2:currentBalance>
                <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
                <ns2:amount>
{
                  let $raw := xs:string(fn:data($Response/ns1:operationData/ns1:CDOD_O_0007))
                  let $len := string-length($raw)
                  let $intPart := substring($raw, 1, $len - 2)
                  let $fracPart := substring($raw, $len - 1)
                  return xs:decimal(concat($intPart, ".", $fracPart))
                }
</ns2:amount>
            </ns2:currentBalance>
            <ns2:productId>001</ns2:productId>
            <ns2:accountType>CURRENT</ns2:accountType>
            <ns2:holdingPattern>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0021)}</ns2:holdingPattern>
            <ns2:hasSweepOutInstruction>false</ns2:hasSweepOutInstruction>
            <ns2:averageQuarterlyBalance></ns2:averageQuarterlyBalance>
            <ns2:averageMonthlyBalance></ns2:averageMonthlyBalance>
            <ns2:lienAmount>
                <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:lienAmount>
            <ns2:sweepInAmount>
                <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:sweepInAmount>
            <ns2:unclearFund>
                <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
                <ns2:amount>{fn-bea:format-number(fn:data($Response/ns1:operationData/ns1:CDOD_O_0010), '0.00')}</ns2:amount>
            </ns2:unclearFund>
            <ns2:fundsAdvanceLimit>
                <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:fundsAdvanceLimit>
            <ns2:hasChequeBookFacility>false</ns2:hasChequeBookFacility>
            <ns2:accountStatusCode>E</ns2:accountStatusCode>
            <ns2:minBalance>{fn-bea:format-number(fn:data($Response/ns1:operationData/ns1:CDOD_O_0012), '0.00')}</ns2:minBalance>
            <ns2:bookBalance>{
                  let $raw := xs:string(fn:data($Response/ns1:operationData/ns1:CDOD_O_0005))
                  let $len := string-length($raw)
                  let $intPart := substring($raw, 1, $len - 2)
                  let $fracPart := substring($raw, $len - 1)
                  return xs:decimal(concat($intPart, ".", $fracPart))
                }</ns2:bookBalance>
            <ns2:customerShortName>{fn:data($Response/ns1:user)}</ns2:customerShortName>
            <ns2:idCustomer>{fn:data($Response/ns1:user)}</ns2:idCustomer>
            <ns2:nbrBranch></ns2:nbrBranch>
            <ns2:nbrAccount></ns2:nbrAccount>
            <ns2:sortCode></ns2:sortCode>
            <ns2:modeOfOperation></ns2:modeOfOperation>
            <ns2:balance>{
                  let $raw := xs:string(fn:data($Response/ns1:operationData/ns1:CDOD_O_0007))
                  let $len := string-length($raw)
                  let $intPart := substring($raw, 1, $len - 2)
                  let $fracPart := substring($raw, $len - 1)
                  return xs:decimal(concat($intPart, ".", $fracPart))
                }</ns2:balance>
            <ns2:acctType></ns2:acctType>
            <ns2:ccyDesc></ns2:ccyDesc>
            <ns2:descAcctType>U</ns2:descAcctType>
            <ns2:relation></ns2:relation>
            <ns2:overdraftUsageLimit>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0011)}</ns2:overdraftUsageLimit>
            <ns2:hasSweepOutFacility>false</ns2:hasSweepOutFacility>
            <ns2:hasSweepInFacility>false</ns2:hasSweepInFacility>
            <ns2:hasSIFacility>false</ns2:hasSIFacility>
            <ns2:hasOverdraftFacility>{if(fn:data($Response/ns1:operationData/ns1:CDOD_O_0011) > 0 )then 'true' else 'false'}</ns2:hasOverdraftFacility>
            <ns2:unclearFunds>{fn-bea:format-number(fn:data($Response/ns1:operationData/ns1:CDOD_O_0010), '0.00')}</ns2:unclearFunds>
            <ns2:productCode>001</ns2:productCode>
            <ns2:productName></ns2:productName>
            <ns2:holdAmount>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0009)}</ns2:holdAmount>
            <ns2:dailyWithdrawalLimit></ns2:dailyWithdrawalLimit>
            <ns2:netBalance>{fn-bea:format-number(fn:data($Response/ns1:operationData/ns1:CDOD_O_0007), '0.00')}</ns2:netBalance>
            <ns2:accountModule>N</ns2:accountModule>
            <ns2:isLMEnabled>false</ns2:isLMEnabled>
            <ns2:partyAccountRelationship></ns2:partyAccountRelationship>
            <ns2:hostRelationshipCode></ns2:hostRelationshipCode>
            <ns2:iban>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0025)}</ns2:iban>
            <ns2:noOfDebitCards></ns2:noOfDebitCards>
            <ns2:atmEnabled>false</ns2:atmEnabled> 
            <ns2:isNomineeRegistered>false</ns2:isNomineeRegistered>
        </ns2:account> else()
        }
        </ns2:data>
    </ns2:Response>
};

local:func($Response)