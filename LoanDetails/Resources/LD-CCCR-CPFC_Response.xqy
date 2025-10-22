xquery version "1.0" encoding "utf-8";
  
  (:: OracleAnnotationVersion "1.0" ::)
  
  declare namespace ns2="http://www.mozabanca.org/cpfc";
  (:: import schema at "LoanFetch/Schema/CPFC.xsd" ::)
  declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
  (:: import schema at "LoanFetch/Schema/CCCR-CCRD.xsd" ::)
  declare namespace ns3="http://www.mozabank.org/LoanDetails";
  (:: import schema at "LOAN_DETAILS.xsd" ::)
declare namespace dvm="http://www.oracle.com/osb/xpath-functions/dvm";
  declare variable $ResponseCccr as element() (:: schema-element(ns1:CCCRResponse) ::) external;
  declare variable $ResponseCpfc as element() (:: schema-element(ns2:CPFCResponse) ::) external;
  declare variable $loanAccountVar as xs:string external;
  declare function local:func($ResponseCccr as element() (:: schema-element(ns1:CCCRResponse) ::), 
                              $ResponseCpfc as element() (:: schema-element(ns2:CPFCResponse) ::),$loanAccountVar) 
                              as element() (:: schema-element(ns3:LoanDetailsResponse) ::) { 
      let $cccr := $ResponseCccr/ns1:operationData/ns1:CCCR_O_0003[ns1:CCCR_O_0003_0001 = $loanAccountVar]
    let $errCode := fn:data($ResponseCccr/ns1:errorCode)
      return
      <ns3:LoanDetailsResponse>
          <ns3:data>
              <ns3:dictionaryArray></ns3:dictionaryArray>
              <ns3:referenceNo></ns3:referenceNo>
              <ns3:result>
                  <ns3:dictionaryArray></ns3:dictionaryArray> 
                  <ns3:externalReferenceId></ns3:externalReferenceId>
	  <ns3:status>
            { if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }
          </ns3:status>
          {
            if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
            else if ($errCode = 'C') then 
              <ns2:errorList>
                <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
                <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
              </ns2:errorList>
            else if ($errCode = '906' or $errCode = 'A') then 
              <ns2:errorList>
                <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode',"ERR001") }</ns2:code>
                <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
              </ns2:errorList>
            else
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
              </ns2:errorList>
          }

                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
             { if ($errCode = '0') then
            <ns3:loanAccount>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($ResponseCccr/ns1:user)}</ns3:partyId>
                <ns3:accountId>{fn:data($cccr/ns1:CCCR_O_0003_0001)}</ns3:accountId>
                <ns3:branchId>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0003)}</ns3:branchId>
                <ns3:productId>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0002)}</ns3:productId>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:accountOpeningDate>
                {let $date := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0005) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:accountOpeningDate>
                <ns3:term>{ 

        let $initDateStr := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0005)
        let $dueDateStr := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0006)
        
        let $initialDate := xs:date(concat(substring($initDateStr, 1, 4), '-', substring($initDateStr, 5, 2), '-', substring($initDateStr, 7, 2)))
        let $dueDate := xs:date(concat(substring($dueDateStr, 1, 4), '-', substring($dueDateStr, 5, 2), '-', substring($dueDateStr, 7, 2)))
        
        let $startYear := fn:year-from-date($initialDate)
        let $startMonth := fn:month-from-date($initialDate)
        let $startDay := fn:day-from-date($initialDate)
        
        let $endYear := fn:year-from-date($dueDate)
        let $endMonth := fn:month-from-date($dueDate)
        let $endDay := fn:day-from-date($dueDate)
        
        let $yearDiff := $endYear - $startYear
        let $monthDiff := $endMonth - $startMonth
        let $dayDiff := $endDay - $startDay
        
        let $adjYears := if ($monthDiff < 0 or ($monthDiff = 0 and $dayDiff < 0)) then $yearDiff - 1 else $yearDiff
        let $adjMonths := 
            if ($monthDiff < 0) then 12 + $monthDiff
            else if ($monthDiff = 0 and $dayDiff < 0) then 11
            else $monthDiff
        
        let $intermediateDate := $initialDate + xs:yearMonthDuration(concat('P', $adjYears, 'Y', $adjMonths, 'M'))
        let $adjDays := fn:days-from-duration($dueDate - $intermediateDate)
        
        return (
          <ns3:years>{ $adjYears }</ns3:years>,
          <ns3:months>{ $adjMonths }</ns3:months>,
          <ns3:days>{ $adjDays }</ns3:days>
        )
        }

                </ns3:term>
                <ns3:sanctionedAmount>
    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012) div 100, '#0.00')}</ns3:amount>
</ns3:sanctionedAmount>

                <ns3:disbursedAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012) div 100, '#0.00')}</ns3:amount>
                </ns3:disbursedAmount>
                <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                <ns3:closureDate>
                {let $date := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:closureDate>
                <ns3:penaltyRate>0</ns3:penaltyRate>
                <ns3:prepaymentPenaltyRate>0</ns3:prepaymentPenaltyRate>
                <ns3:noOfLinkage>1</ns3:noOfLinkage>
                <ns3:firstDisbursementDate>
                {let $date := fn:data($ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003[ns2:CPFC_O_0003_0001 = 'U']/ns2:CPFC_O_0003_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:firstDisbursementDate>
                <ns3:lastDisbursementDate>
                {let $date := fn:data($ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003[ns2:CPFC_O_0003_0001 = 'U']/ns2:CPFC_O_0003_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:lastDisbursementDate>
<ns3:interestRate>
  {fn-bea:format-number(
      xs:decimal($cccr/ns1:CCRD/ns1:CCRD_O_0011) div 100000,
      '#0.00000')}
</ns3:interestRate>

                <ns3:maturityDate>
                {let $date := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:maturityDate>
                <ns3:noOfInstallments>0</ns3:noOfInstallments>
                <ns3:outstandingAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCCR_O_0003_0005) div 100, '#0.00')}</ns3:amount>
                </ns3:outstandingAmount>
                <ns3:totalAmountRepaid>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>
                    {fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012) - fn:data($cccr/ns1:CCCR_O_0003_0005), '0.00')}
                    </ns3:amount>
                </ns3:totalAmountRepaid>
                <ns3:module>CON</ns3:module>
                <ns3:description>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0002)}</ns3:description>
                <ns3:partyName>{fn:data($ResponseCccr/ns1:user)}</ns3:partyName>
                <ns3:paymentType></ns3:paymentType>
                <ns3:tenure> 
                {
                  let $startDate := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0005)
                  let $endDate := fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0006)
                  let $start := xs:date(concat(substring($startDate, 1, 4), '-', substring($startDate, 5, 2), '-', substring($startDate, 7, 2)))
                  let $end := xs:date(concat(substring($endDate, 1, 4), '-', substring($endDate, 5, 2), '-', substring($endDate, 7, 2)))
                  return days-from-duration($end - $start)
                }
                </ns3:tenure>
                <ns3:linkages></ns3:linkages>
                <ns3:outstandingLoanDetailsDTO>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:refLinks></ns3:refLinks>
                    <ns3:accountId>
                        <ns3:displayValue>{fn:data($cccr/ns1:CCCR_O_0003_0001)}</ns3:displayValue>
                        <ns3:value>{fn:data($cccr/ns1:CCCR_O_0003_0001)}</ns3:value>
                    </ns3:accountId>
                    <ns3:principalBalance>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012), '#0.00')}</ns3:amount>
                    </ns3:principalBalance>
                    <ns3:interestAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0017), '#0.00')}</ns3:amount>
                    </ns3:interestAmount>
                    <ns3:penaltyInterestAmount></ns3:penaltyInterestAmount>
                    <ns3:prepaymentAmount></ns3:prepaymentAmount>
                    <ns3:outstandingAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                      <ns3:amount>
  {fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0013) div 100, '#0.00')}
</ns3:amount>

                    </ns3:outstandingAmount>
                    <ns3:serviceCharges></ns3:serviceCharges>
                    <ns3:installmentArrear></ns3:installmentArrear>
                    <ns3:prepaymentPenaltyAmount></ns3:prepaymentPenaltyAmount>
                    <ns3:penaltyAmount></ns3:penaltyAmount>
                    <ns3:lateRepaymentCharges></ns3:lateRepaymentCharges>
                    <ns3:repaymentAmount></ns3:repaymentAmount>
                    <ns3:component></ns3:component>
                    <ns3:componentName></ns3:componentName>
                    <ns3:amountPaid></ns3:amountPaid>
                    <ns3:recomputationBasis></ns3:recomputationBasis>
                    <ns3:interestArrears></ns3:interestArrears>
                    <ns3:principalArrears></ns3:principalArrears>
                </ns3:outstandingLoanDetailsDTO>
                <ns3:principalOutstandingAmountLcy>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0016) div 100, '#0.00')}</ns3:amount>
                </ns3:principalOutstandingAmountLcy>
                <ns3:interestOutstandingAmountLcy>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0017) div 100, '#0.00')}</ns3:amount>
                </ns3:interestOutstandingAmountLcy>
                <ns3:totalOutstandingAmountLcy>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0013) div 100, '#0.00')}</ns3:amount>
                </ns3:totalOutstandingAmountLcy>
                <ns3:currencyCodeLcy>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currencyCodeLcy>
                <ns3:interestOutstandingAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0017) div 100, '#0.00')}</ns3:amount>
                </ns3:interestOutstandingAmount>
                <ns3:totalOutstandingAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0013) div 100, '#0.00')}</ns3:amount>
                </ns3:totalOutstandingAmount>
                <ns3:interestOSBalMaturity>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0017) div 100, '#0.00')}</ns3:amount>
                </ns3:interestOSBalMaturity>
                <ns3:totalOSBalMaturity>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0013) div 100, '#0.00')}</ns3:amount>
                </ns3:totalOSBalMaturity>
                <ns3:sortCode>{fn:data($cccr/ns1:CCCR_O_0003_0006)}</ns3:sortCode>
                <ns3:hostRelationshipCode></ns3:hostRelationshipCode>
                <ns3:relationshipType></ns3:relationshipType>
            </ns3:loanAccount> else()
            }
            { if ($errCode = '0') then
			
            <ns3:loanScheduleDetails>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:amountDue>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:long(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0009)) div 100, '#0.00')}</ns3:amount>
                </ns3:amountDue>
                <ns3:amountPaid>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012) - fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0013) , '0.00')}</ns3:amount>
                </ns3:amountPaid>
                <ns3:installementDueCount></ns3:installementDueCount>
                <ns3:installementPaidCount></ns3:installementPaidCount>
                <ns3:nextInstallmentAmount>
                    <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                   <ns3:amount>
{
  fn-bea:format-number(
    xs:decimal(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0009)) div 100,
    '#0.00'
  )
}
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
		 for $i at $pos in (distinct-values($ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003/ns2:CPFC_O_0003_0002))
                 let $loanItem := $ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003[ns2:CPFC_O_0003_0002 = $i]
                 let $count := count(distinct-values($ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003/ns2:CPFC_O_0003_0002)) 
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
						 $ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003[$pos + 1]/ns2:CPFC_O_0003_0003
					   )) div 100,
					   '#0.00'
					 )
			  }
			 </ns3:amount> 
                    </ns3:nextInstallmentAmount>
                    <ns3:interestAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
						<ns3:amount>
						  {fn-bea:format-number(
							  xs:decimal(fn:data($loanItem[ns2:CPFC_O_0003_0001 = 'J']/ns2:CPFC_O_0003_0004)) div 100,
							  '#0.00')}
						</ns3:amount>
                    </ns3:interestAmtPaid>
                    <ns3:principalAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount></ns3:amount>
                    </ns3:principalAmtPaid>
                </ns3:loanScheduleItemDetails> 
                else if(fn:data($cccr/ns1:CCCR_O_0003_0007) = 'CRR') then
                 for $loanItem at $pos in $ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003[ns2:CPFC_O_0003_0001 = 'R' or ns2:CPFC_O_0003_0001 = 'J']
                 let $count := count(distinct-values($ResponseCpfc/*:operationData/*:CPFC_O_0003/*:CPFC_O_0003_0002)) 
		 return
                <ns3:loanScheduleItemDetails>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:principalAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(xs:int(fn:data($loanItem/ns2:CPFC_O_0003_0005)) div 100, '#0.00')}
</ns3:amount> 
                    </ns3:principalAmount>
                    <ns3:interestAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($loanItem/ns2:CPFC_O_0003_0004) div 100, '#0.00')}
</ns3:amount>
                    </ns3:interestAmount>
                    <ns3:balanceAmount>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                      <ns3:amount>
					  {fn-bea:format-number(
						  (xs:decimal(fn:data($loanItem/ns2:CPFC_O_0003_0005)) -
						   xs:decimal(fn:data($loanItem/ns2:CPFC_O_0003_0004)))
						  div 100,
						  '#0.00')}
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
    '#0.00')}
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
									 $ResponseCpfc/ns2:operationData/ns2:CPFC_O_0003[$pos + 1]/ns2:CPFC_O_0003_0003
								   )) div 100,
								   '0.00'
								 )
						  }
						</ns3:amount>

                    </ns3:nextInstallmentAmount>
                    <ns3:interestAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($loanItem/ns2:CPFC_O_0003_0004) div 100, '#0.00')}
</ns3:amount>
                    </ns3:interestAmtPaid>
                    <ns3:principalAmtPaid>
                        <ns3:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount></ns3:amount>
                    </ns3:principalAmtPaid>
                </ns3:loanScheduleItemDetails>
                else()
                } 
                 { if ($errCode = '0') then
                <ns3:partyId>{fn:data($ResponseCccr/ns1:user)}</ns3:partyId>
                else()
                }
            </ns3:loanScheduleDetails>
            else()
            }
        </ns3:data>
    </ns3:LoanDetailsResponse>
};

local:func($ResponseCccr, $ResponseCpfc,$loanAccountVar)