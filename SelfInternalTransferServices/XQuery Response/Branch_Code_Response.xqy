xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/branchCode";
(:: import schema at "../Schema/OBDXSchema/BRANCH_CODE.xsd" ::)
declare namespace ns1="http://www.mozabank.org/cdod";
(:: import schema at "../Schema/MSBSchema/CDOD.xsd" ::)

declare variable $CDOD_Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($CDOD_Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>                  
                  {
                    if (fn:data($CDOD_Response/ns1:errorCode) = '0')
                    then 'SUCCESS'
                    else 'FAILURE'
                  }
                  </ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:account>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId></ns2:partyId>
                <ns2:branchId>{fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0003)}</ns2:branchId>
                <ns2:accountId></ns2:accountId>
                <ns2:currency></ns2:currency>
                <ns2:status></ns2:status>
                <ns2:availableBalance></ns2:availableBalance>
                <ns2:averageBalance></ns2:averageBalance>
                <ns2:interestType></ns2:interestType>
                <ns2:interestRate></ns2:interestRate>
                <ns2:openingDate></ns2:openingDate>
                <ns2:module></ns2:module>
                <ns2:accountDisplayName></ns2:accountDisplayName>
                <ns2:currentBalance></ns2:currentBalance>
                <ns2:productId></ns2:productId>
                <ns2:accountType></ns2:accountType>
                <ns2:holdingPattern></ns2:holdingPattern>
                <ns2:hasSweepOutInstruction>false</ns2:hasSweepOutInstruction>
                <ns2:averageQuarterlyBalance></ns2:averageQuarterlyBalance>
                <ns2:averageMonthlyBalance></ns2:averageMonthlyBalance>
                <ns2:lienAmount></ns2:lienAmount>
                <ns2:sweepInAmount></ns2:sweepInAmount>
                <ns2:unclearFund></ns2:unclearFund>
                <ns2:fundsAdvanceLimit></ns2:fundsAdvanceLimit>
                <ns2:hasChequeBookFacility>false</ns2:hasChequeBookFacility>
                <ns2:accountStatusCode></ns2:accountStatusCode>
                <ns2:minBalance>{fn-bea:format-number(xs:long(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0012)), '0.00')}</ns2:minBalance>
				 <ns2:bookBalance>
						{
						  let $amount := xs:decimal(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0005)) div 100
						  return
							if ($amount = xs:integer($amount)) then
							  concat(xs:string($amount), '.00')
							else
							  let $str := xs:string($amount),
								  $dec := substring-after($str, '.'),
								  $pad := substring('00', string-length($dec) + 1)
							  return concat(substring-before($str, '.'), '.', $dec, $pad)
						}
			</ns2:bookBalance>               
				<ns2:customerShortName></ns2:customerShortName>
                <ns2:idCustomer></ns2:idCustomer>
                <ns2:nbrBranch></ns2:nbrBranch>
                <ns2:nbrAccount></ns2:nbrAccount>
                <ns2:sortCode></ns2:sortCode>
                <ns2:modeOfOperation></ns2:modeOfOperation>
                  <ns2:balance>
								{
								  let $amount := xs:decimal(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0007)) div 100
								  return
									if ($amount = xs:integer($amount)) then
									  concat(xs:string($amount), '.00')
									else
									  let $str := xs:string($amount),
										  $dec := substring-after($str, '.'),
										  $pad := substring('00', string-length($dec) + 1)
									  return concat(substring-before($str, '.'), '.', $dec, $pad)
								}
					</ns2:balance>
                <ns2:acctType></ns2:acctType>
                <ns2:ccyDesc></ns2:ccyDesc>
                <ns2:descAcctType></ns2:descAcctType>
                <ns2:relation></ns2:relation>
                <ns2:overdraftUsageLimit>{fn-bea:format-number(xs:long(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0011)), '0.00')}</ns2:overdraftUsageLimit>
                <ns2:hasSweepOutFacility>false</ns2:hasSweepOutFacility>
                <ns2:hasSweepInFacility>false</ns2:hasSweepInFacility>
                <ns2:hasSIFacility>false</ns2:hasSIFacility>
                <ns2:hasOverdraftFacility>{if(fn:data(xs:int($CDOD_Response/ns1:operationData/ns1:CDOD_O_0011) )> 0) then 'true' else 'false'}</ns2:hasOverdraftFacility>
             
     <ns2:unclearFunds>
            {
              let $amount := xs:decimal(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0010)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }
</ns2:unclearFunds>
                <ns2:productCode></ns2:productCode>
                <ns2:productName></ns2:productName>
               
				 <ns2:holdAmount>
						{
						  let $amount := xs:decimal(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0009)) div 100
						  return
							if ($amount = xs:integer($amount)) then
							  concat(xs:string($amount), '.00')
							else
							  let $str := xs:string($amount),
								  $dec := substring-after($str, '.'),
								  $pad := substring('00', string-length($dec) + 1)
							  return concat(substring-before($str, '.'), '.', $dec, $pad)
						}
				</ns2:holdAmount>
                <ns2:dailyWithdrawalLimit></ns2:dailyWithdrawalLimit>
				<ns2:netBalance>
							{
							  let $amount := xs:decimal(fn:data($CDOD_Response/ns1:operationData/ns1:CDOD_O_0007)) div 100
							  return
								if ($amount = xs:integer($amount)) then
								  concat(xs:string($amount), '.00')
								else
								  let $str := xs:string($amount),
									  $dec := substring-after($str, '.'),
									  $pad := substring('00', string-length($dec) + 1)
								  return concat(substring-before($str, '.'), '.', $dec, $pad)
							}
				</ns2:netBalance>
                <ns2:accountModule></ns2:accountModule>
                <ns2:isLMEnabled></ns2:isLMEnabled>
                <ns2:partyAccountRelationship></ns2:partyAccountRelationship>
                <ns2:hostRelationshipCode></ns2:hostRelationshipCode>
                <ns2:iban></ns2:iban>
                <ns2:noOfDebitCards></ns2:noOfDebitCards>
                <ns2:atmEnabled>false</ns2:atmEnabled>  
            </ns2:account>
        </ns2:data>
    </ns2:Response>
};

local:func($CDOD_Response)