xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns3="http://www.mozabank.org/LoanAccountFetch";
(:: import schema at "Schema/LOAN_ACCOUNTS_FETCH.xsd" ::)

declare variable $CccrResponse as element() (:: schema-element(ns1:CCCR_ITEM) ::) external;
declare variable $CpfcResponse as element() (:: schema-element(ns2:CPFCResponse) ::) external;
declare variable $userIdVar as xs:string external;
declare function local:func($CccrResponse as element() (:: schema-element(ns1:CCCR_ITEM) ::), 
                            $CpfcResponse as element() (:: schema-element(ns2:CPFCResponse) ::),$userIdVar) 
                            as element() (:: schema-element(ns3:Response) ::) {
  
            <ns3:loanAccounts>
                <ns3:partyId>{$userIdVar}</ns3:partyId>
                <ns3:accountId>{fn:data($CccrResponse/ns1:CCCR_O_0003_0001)}</ns3:accountId>
                <ns3:branchId>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0003)}</ns3:branchId>
                <ns3:productId>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0002)}</ns3:productId>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:accountOpeningDate>
                {let $date := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0005) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:accountOpeningDate>
                <ns3:term>
                      {
                      let $initDate := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0005)
                      let $dDate := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0006)
                      let $initialDate := xs:date(concat(substring($initDate, 1, 4), '-', substring($initDate, 5, 2), '-', substring($initDate, 7, 2)))
                      let $dueDate := xs:date(concat(substring($dDate, 1, 4), '-', substring($dDate, 5, 2), '-', substring($dDate, 7, 2)))
                      let $duration := $dueDate - $initialDate
                      let $totalMonths := months-from-duration($duration)
                      let $years := floor(xs:decimal($totalMonths) div 12)
                      let $months := $totalMonths mod 12
                      let $days := days-from-duration($duration)
                      return (
                        <ns3:days>{ $days }</ns3:days>,
                        <ns3:months>{ $months }</ns3:months>,
                        <ns3:years>{ $years }</ns3:years>
                      )
                    }
                </ns3:term>
                <ns3:sanctionedAmount>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCCR_O_0003_0006)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0012), '0.00')}</ns3:amount>
                </ns3:sanctionedAmount>
                <ns3:disbursedAmount>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCCR_O_0003_0006)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0012), '0.00')}</ns3:amount>
                </ns3:disbursedAmount>
                <ns3:currency>{fn:data($CccrResponse/ns1:CCCR_O_0003_0006)}</ns3:currency>
                <ns3:closureDate>
                {let $date := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:closureDate>
                <ns3:penaltyRate>0</ns3:penaltyRate>
                <ns3:prepaymentPenaltyRate>0</ns3:prepaymentPenaltyRate>
                <ns3:noOfLinkage>1</ns3:noOfLinkage>
                <ns3:firstDisbursementDate>
                {let $date := fn:data($CpfcResponse/ns2:operationData/ns2:CPFC_O_0003[1]/ns2:CPFC_O_0003_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:firstDisbursementDate>
                <ns3:lastDisbursementDate>
                {let $date := fn:data($CpfcResponse/ns2:operationData/ns2:CPFC_O_0003[1]/ns2:CPFC_O_0003_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:lastDisbursementDate>
                <ns3:interestRate>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0011)}</ns3:interestRate>
                <ns3:maturityDate>
                {let $date := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:maturityDate>
                <ns3:noOfInstallments>0</ns3:noOfInstallments>
                <ns3:outstandingAmount>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCCR_O_0003_0006)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCCR_O_0003_0005), '0.00')}</ns3:amount>
                </ns3:outstandingAmount>
                <ns3:totalAmountRepaid>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>
                    {fn-bea:format-number(fn:data($CccrResponse/ns1:CCCR_O_0003_0005) - fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0012), '0.00')}
                    </ns3:amount>
                </ns3:totalAmountRepaid>
                <ns3:module>CON</ns3:module>
                <ns3:description>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0002)}</ns3:description>
                <ns3:partyName>{$userIdVar}</ns3:partyName>
                <ns3:paymentType></ns3:paymentType>
                <ns3:tenure>{
                  let $startDate := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0005)
                  let $endDate := fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0006)
                  let $start := xs:date(concat(substring($startDate, 1, 4), '-', substring($startDate, 5, 2), '-', substring($startDate, 7, 2)))
                  let $end := xs:date(concat(substring($endDate, 1, 4), '-', substring($endDate, 5, 2), '-', substring($endDate, 7, 2)))
                  return days-from-duration($end - $start)
                }</ns3:tenure>
                <ns3:corpModule></ns3:corpModule>
                <ns3:linkages></ns3:linkages>
                <ns3:outstandingLoanDetailsDTO>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:refLinks></ns3:refLinks>
                    <ns3:accountId>
                        <ns3:displayValue></ns3:displayValue>
                        <ns3:value>{fn:data($CccrResponse/ns1:CCCR_O_0003_0001)}</ns3:value>
                    </ns3:accountId>
                    <ns3:principalBalance>
                        <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0012), '0.00')}</ns3:amount>
                    </ns3:principalBalance>
                    <ns3:interestAmount>
                        <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0017), '0.00')}</ns3:amount>
                    
                    </ns3:interestAmount>
                    <ns3:penaltyInterestAmount></ns3:penaltyInterestAmount>
                    <ns3:prepaymentAmount></ns3:prepaymentAmount>
                    <ns3:outstandingAmount>
                        <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0013), '0.00')}</ns3:amount>
                        
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
                    <ns3:amountDue></ns3:amountDue>
                    <ns3:recomputationBasis></ns3:recomputationBasis>
                    <ns3:interestArrears></ns3:interestArrears>
                    <ns3:principalArrears></ns3:principalArrears>
                    <ns3:interestAmount></ns3:interestAmount>
                </ns3:outstandingLoanDetailsDTO>
                <ns3:principalOutstandingAmountLcy>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0016), '0.00')}</ns3:amount>
                    
                </ns3:principalOutstandingAmountLcy>
                <ns3:interestOutstandingAmountLcy>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0017), '0.00')}</ns3:amount>
                    
                </ns3:interestOutstandingAmountLcy>
                <ns3:totalOutstandingAmountLcy>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0013), '0.00')}</ns3:amount>
                    
                </ns3:totalOutstandingAmountLcy>
                <ns3:currencyCodeLcy>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currencyCodeLcy>
                <ns3:interestOutstandingAmount>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0017), '0.00')}</ns3:amount>
                    
                </ns3:interestOutstandingAmount>
                <ns3:totalOutstandingAmount>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0013), '0.00')}</ns3:amount>
                    
                </ns3:totalOutstandingAmount>
                <ns3:interestOSBalMaturity>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0017), '0.00')}</ns3:amount>
                    
                </ns3:interestOSBalMaturity>
                <ns3:totalOSBalMaturity>
                    <ns3:currency>{fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($CccrResponse/ns1:CCRD/ns1:CCRD_O_0013), '0.00')}</ns3:amount>
                    
                </ns3:totalOSBalMaturity>
                <ns3:sortCode>{fn:data($CccrResponse/ns1:CCCR_O_0003_0006)}</ns3:sortCode>
                <ns3:hostRelationshipCode></ns3:hostRelationshipCode>
                <ns3:relationshipType></ns3:relationshipType>
            </ns3:loanAccounts> 
};

local:func($CccrResponse, $CpfcResponse,$userIdVar)