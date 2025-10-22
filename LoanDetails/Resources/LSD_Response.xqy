xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cpfc";
(:: import schema at "CPFC.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "LoanFetch/Schema/CCCR-CCRD.xsd" ::)
declare namespace ns3="http://www.mozabank.org/LoanScheduleDetails";
(:: import schema at "LOAN_SCHEDULE_DETAILS.xsd" ::)
declare namespace dvm="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response-LSD as element() (:: schema-element(ns1:CCCRResponse) ::) external;
declare variable $ResponseCPFC as element() (:: schema-element(ns2:CPFCResponse) ::) external;
  declare variable $loanAccountVar as xs:string external;

declare function local:func($Response-LSD as element() (:: schema-element(ns1:CCCRResponse) ::), 
                            $ResponseCPFC as element() (:: schema-element(ns2:CPFCResponse) ::),$loanAccountVar) 
                            as element() (:: schema-element(ns3:LoanScheduleDetailsResponse) ::) {
    let $errCode := fn:data($Response-LSD/*:errorCode)
    return
    <ns3:LoanScheduleDetailsResponse>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>{if($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE'}</ns3:status>
                {
                 if($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
                 else if($errCode = 'C') then 
                 (
                    <ns3:errorList>
                        <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response-LSD/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns3:code>
                        <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response-LSD/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($Response-LSD/*:errorMessage/*:messages[1])),'-')) }</ns3:message>
                    </ns3:errorList>
                 )
                 else if($errCode = '906' or $errCode = 'A') then 
                 (
                    <ns3:errorList>
                        <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode',"ERR001") }</ns3:code>
                        <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($Response-LSD/*:errorMessage/*:messages[1])),'-')) }</ns3:message>
                    </ns3:errorList>
                 )
                 else
                 (
                    <ns3:errorList>
                        <ns3:code>ERR001</ns3:code>
                        <ns3:message>Invalid backend response</ns3:message>
                    </ns3:errorList>
                 )
                }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            {
             if($errCode = '0' or $errCode = 'P' or $errCode = 'B') then
             let $cccr := $Response-LSD/ns1:operationData/ns1:CCCR_O_0003[ns1:CCCR_O_0003_0001 = $loanAccountVar]
            return  
            <ns3:loanScheduleDetails>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:amountDue>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>
  {fn-bea:format-number(
      xs:decimal(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0009)) div 100,
      '0.00')}
</ns3:amount>

                </ns3:amountDue>
                <ns3:amountPaid>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>
  {fn-bea:format-number(
      xs:decimal(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0009)) div 100,
      '0.00')}
</ns3:amount>

                </ns3:amountPaid>
                <ns3:installementDueCount>0</ns3:installementDueCount>
                <ns3:installementPaidCount>0</ns3:installementPaidCount>
                <ns3:nextInstallmentAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                  <ns3:amount>
  {fn-bea:format-number(
      xs:decimal(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0009)) div 100,
      '0.00')}
</ns3:amount>

                </ns3:nextInstallmentAmount>
            <ns3:nextDueDate>
                {let $date := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0008) return 
                      if (normalize-space($date) != '') then
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}           
                </ns3:nextDueDate>
                <ns3:interestRepaymentFrequency></ns3:interestRepaymentFrequency>
                <ns3:principalRepaymentFrequency></ns3:principalRepaymentFrequency>
                <ns3:numberOfInstallment>0</ns3:numberOfInstallment>
		{
                 if(fn:data($cccr/ns1:CCCR_O_0003_0007) = 'CRF')then
		 for $i at $pos in (distinct-values($ResponseCPFC/ns2:operationData/ns2:CPFC_O_0003/ns2:CPFC_O_0003_0002))
                 let $loanItem := $ResponseCPFC/ns2:operationData/ns2:CPFC_O_0003[ns2:CPFC_O_0003_0002 = $i]
                 let $count := count(distinct-values($ResponseCPFC/ns2:operationData/ns2:CPFC_O_0003/ns2:CPFC_O_0003_0002)) 
		 return
                <ns3:loanScheduleItemDetails>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:principalAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        { if (count($loanItem[ns2:CPFC_O_0003_0001 = 'A']) > 0) then
			<ns3:amount>
			{fn-bea:format-number(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'A']/ns2:CPFC_O_0003_0003) div 100, '0.00')}
			</ns3:amount>
                        else (<ns3:amount/>)
                        }
                    </ns3:principalAmount>
                    <ns3:interestAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
			<ns3:amount>
			  {fn-bea:format-number(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'J']/ns2:CPFC_O_0003_0003) div 100, '0.00')}
			</ns3:amount>
                    </ns3:interestAmount>
                    <ns3:balanceAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        {if (count($loanItem[ns2:CPFC_O_0003_0001 = 'A']) > 0) then
			<ns3:amount>
			  {fn-bea:format-number(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'A']/ns2:CPFC_O_0003_0003) div 100, '0.00')}
			</ns3:amount>
                        else (<ns3:amount/>)
                        }                        
                    </ns3:balanceAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:installmentAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
			 {
			 if (count($loanItem[ns2:CPFC_O_0003_0001 = 'A']) > 0) then
			 <ns3:amount>
			   { fn-bea:format-number(
			 	  (
			 		xs:decimal(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'A']/ns2:CPFC_O_0003_0003))
			 		+
			 		xs:decimal(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'J']/ns2:CPFC_O_0003_0003))
			 	  ) div 100,
			 	  '0.00'
			 	)
			   }
			 </ns3:amount>
			 else
			 <ns3:amount>
			   { fn-bea:format-number(
			 	  (
			 		xs:decimal(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'J']/ns2:CPFC_O_0003_0003))
			 	  ) div 100,
			 	  '0.00'
			 	)
			   }
			 </ns3:amount>
			 	 }
                    </ns3:installmentAmount>
                    {
                    if (count($loanItem[ns2:CPFC_O_0003_0001 = 'A']) > 0) then
                    <ns3:installmentDueDate>
                    { 
                    let $date := fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'A']/ns2:CPFC_O_0003_0006) return  
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    }
                    </ns3:installmentDueDate>
                    else <ns3:installmentDueDate/>
                    }
                    {
                    if (count($loanItem[ns2:CPFC_O_0003_0001 = 'A']) > 0) then
                    <ns3:paymentStatus>{fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'A']/ns2:CPFC_O_0003_0007)}</ns3:paymentStatus>
                    else(<ns3:paymentStatus>{fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'J ']/ns2:CPFC_O_0003_0007)}</ns3:paymentStatus>)
                    }
                    <ns3:chargeAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>0.00</ns3:amount>
                    </ns3:chargeAmount>
                    <ns3:interestRate>{xs:long(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0011)) div 100000}</ns3:interestRate>
                    <ns3:unpaidInstallmentAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        { if (count($loanItem[ns2:CPFC_O_0003_0001 = 'A']) > 0) then
			<ns3:amount>
			  {fn-bea:format-number(
				  xs:decimal(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'A']/ns2:CPFC_O_0003_0005)) div 100,
				  '0.00')}
			</ns3:amount>
                            else <ns3:amount/>
                            }
                    </ns3:unpaidInstallmentAmount>
                    <ns3:nextInstallmentAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>
			  {
				if ($pos = $count)
				then '0.00'
				else fn-bea:format-number(
					   xs:decimal(fn:data(
						 $ResponseCPFC/ns2:operationData/ns2:CPFC_O_0003[$pos + 1]/ns2:CPFC_O_0003_0003
					   )) div 100,
					   '0.00'
					 )
			  }
			 </ns3:amount> 
                    </ns3:nextInstallmentAmount>
                    <ns3:interestAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
						<ns3:amount>
						  {fn-bea:format-number(
							  xs:decimal(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'J']/ns2:CPFC_O_0003_0004)) div 100,
							  '0.00')}
						</ns3:amount>
                    </ns3:interestAmtPaid>
                    <ns3:principalAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount></ns3:amount>
                    </ns3:principalAmtPaid>
                </ns3:loanScheduleItemDetails> 
                else if(fn:data($cccr/ns1:CCCR_O_0003_0007) = 'CRR') then
                 for $loanItem at $pos in $ResponseCPFC/ns2:operationData/ns2:CPFC_O_0003[ns2:CPFC_O_0003_0001 = 'R' or ns2:CPFC_O_0003_0001 = 'J']
                 let $count := count(distinct-values($ResponseCPFC/*:operationData/*:CPFC_O_0003/*:CPFC_O_0003_0002)) 
		 return
                <ns3:loanScheduleItemDetails>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:principalAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(xs:int(fn:data($loanItem/ns2:CPFC_O_0003_0005)) div 100, '0.00')}
</ns3:amount> 
                    </ns3:principalAmount>
                    <ns3:interestAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($loanItem/ns2:CPFC_O_0003_0004) div 100, '0.00')}
</ns3:amount>
                    </ns3:interestAmount>
                    <ns3:balanceAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                      <ns3:amount>
					  {fn-bea:format-number(
						  (xs:decimal(fn:data($loanItem/ns2:CPFC_O_0003_0005)) -
						   xs:decimal(fn:data($loanItem/ns2:CPFC_O_0003_0004)))
						  div 100,
						  '0.00')}
					</ns3:amount>

                    </ns3:balanceAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:installmentAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($loanItem/ns2:CPFC_O_0003_0003) div 100, '0.00')}
</ns3:amount>
                    </ns3:installmentAmount>
                    <ns3:installmentDueDate>
                    {let $date := fn:data($loanItem/ns2:CPFC_O_0003_0006) return 
                      if (normalize-space($date) != '') then
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                    </ns3:installmentDueDate>
                    <ns3:paymentStatus>{fn:data($loanItem/ns2:CPFC_O_0003_0007)}</ns3:paymentStatus>
                    <ns3:chargeAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>0.00</ns3:amount>
                    </ns3:chargeAmount>
                    <ns3:interestRate>{xs:long(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0011)) div 100000}</ns3:interestRate>
                    <ns3:unpaidInstallmentAmount>
                        <ns3:currency>MZN</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(
    xs:decimal(fn:data($loanItem/ns2:CPFC_O_0003_0005)) div 100,
    '0.00')}
</ns3:amount>
                    </ns3:unpaidInstallmentAmount>
                    <ns3:nextInstallmentAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>
						  {
							if ($pos = $count)
							then '0.00'
							else fn-bea:format-number(
								   xs:decimal(fn:data(
									 $ResponseCPFC/ns2:operationData/ns2:CPFC_O_0003[$pos + 1]/ns2:CPFC_O_0003_0003
								   )) div 100,
								   '0.00'
								 )
						  }
						</ns3:amount>

                    </ns3:nextInstallmentAmount>
                    <ns3:interestAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($loanItem/ns2:CPFC_O_0003_0004) div 100, '0.00')}
</ns3:amount>
                    </ns3:interestAmtPaid>
                    <ns3:principalAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount></ns3:amount>
                    </ns3:principalAmtPaid>
                </ns3:loanScheduleItemDetails>
                else()
                } 
                {
             if($errCode = '0') then
                <ns3:partyId>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0010)}</ns3:partyId>
                else()
                }
            </ns3:loanScheduleDetails>
             else()
            }
        </ns3:data>
    </ns3:LoanScheduleDetailsResponse>
};

local:func($Response-LSD, $ResponseCPFC,$loanAccountVar)