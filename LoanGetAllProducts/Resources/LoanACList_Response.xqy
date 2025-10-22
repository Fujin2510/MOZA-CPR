xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns3="http://www.mozabank.org/LOAN_ACCOUNT_LIST";
(:: import schema at "Schema/LOAN_ACCOUNT_LIST.xsd" ::)

 declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CCCRResponse as element() (:: schema-element(ns1:CCCRResponse) ::) external;
declare variable $CPFCResponse as element() (:: schema-element(ns2:CPFCResponse) ::) external;

declare function local:func($CCCRResponse as element() (:: schema-element(ns1:CCCRResponse) ::), 
                            $CPFCResponse as element() (:: schema-element(ns2:CPFCResponse) ::)) 
                            as element() (:: schema-element(ns3:LOAN_ACCOUNT_LISTResponse) ::) {
let $errCode := fn:data($CCCRResponse/ns1:errorCode)
return
    <ns3:LOAN_ACCOUNT_LISTResponse>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                 <ns3:status>{
              if (fn:data($CCCRResponse/ns1:errorCode) = '0') 
              then 'SUCCESS' 
              else 'FAILURE'
            }
            </ns3:status> 
                {
            if ($errCode = '0') then ()
            else if ($errCode = 'C') then (
              <ns3:errorList>
                <ns3:code>
                  { dvm:lookup(
                      'CommonErrorHandlerService/ErrorCodes.dvm',
                      'MSBCode',
                      substring-before(xs:string(fn:data($CCCRResponse/ns1:errorMessage/ns1:messages[1])), '-'),
                      'ErrorCode',
                      'ERR001') }
                </ns3:code>
                <ns3:message>
                  { dvm:lookup(
                      'CommonErrorHandlerService/ErrorCodes.dvm',
                      'MSBCode',
                      substring-before(xs:string(fn:data($CCCRResponse/ns1:errorMessage/ns1:messages[1])), '-'),
                      'ErrorMessageEN',
                      substring-after(xs:string(fn:data($CCCRResponse/ns1:errorMessage/ns1:messages[1])), '-')) }
                </ns3:message>
              </ns3:errorList>
            )
            else if ($errCode = 'A') then (
              <ns3:errorList>
                <ns3:code>
                  { dvm:lookup(
                      'CommonErrorHandlerService/SystemCodes.dvm',
                      'MSBCode',
                      $errCode,
                      'OBDXCode',
                      'ERR001') }
                </ns3:code>
                <ns3:message>{ fn:data($CCCRResponse/ns1:errorMessage/ns1:messages[1]) }</ns3:message>
              </ns3:errorList>
            )
            else (
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
            <!--
{
            if ($errCode = '0') then
              for $acc in $CCCRResponse/ns1:operationData/ns1:CCCR_O_0003
return
            <ns3:loanAccounts>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCCRResponse/ns1:user)}</ns3:partyId>
                <ns3:accountId>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCCR_O_0003_0001)}</ns3:accountId>
                <ns3:branchId>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0003)}</ns3:branchId>
                <ns3:productId>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0002)}</ns3:productId>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:accountOpeningDate>{let $date := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0005) return 
if (normalize-space($date) != '') then
      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
    else ()}</ns3:accountOpeningDate>
  <ns3:term>
       {
                        let $initDate := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0005)
                        let $dDate := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0006)
                        let $initialDate := xs:date(concat(substring($initDate, 1, 4), '-', substring($initDate, 5, 2), '-', substring($initDate, 7, 2)))
                        let $dueDate := xs:date(concat(substring($dDate, 1, 4), '-', substring($dDate, 5, 2), '-', substring($dDate, 7, 2)))
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
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0012)), '0.00')}</ns3:amount>
                </ns3:sanctionedAmount>
                <ns3:disbursedAmount>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0012)), '0.00')}</ns3:amount>
                </ns3:disbursedAmount>
                <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                <ns3:closureDate>
                {let $date := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:closureDate>
                <ns3:penaltyRate>0</ns3:penaltyRate>
                <ns3:prepaymentPenaltyRate>0</ns3:prepaymentPenaltyRate>
                <ns3:noOfLinkage>1</ns3:noOfLinkage>
                <ns3:firstDisbursementDate>
                {let $date := fn:data($CPFCResponse/ns2:operationData/ns2:CPFC_O_0003/ns2:CPFC_O_0003_0006)
                return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:firstDisbursementDate>
                <ns3:lastDisbursementDate>
                {let $date := fn:data($CPFCResponse/ns2:operationData/ns2:CPFC_O_0003/ns2:CPFC_O_0003_0006)
                return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:lastDisbursementDate>
                <ns3:interestRate>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0011)}</ns3:interestRate>
                <ns3:maturityDate>
                {let $date := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0006) return 
                if (normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns3:maturityDate>
                <ns3:noOfInstallments>0</ns3:noOfInstallments>
                <ns3:outstandingAmount>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCCR_O_0003_0005)),'0.00')}</ns3:amount>
                </ns3:outstandingAmount>
                <ns3:totalAmountRepaid>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(
                      xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0012)) 
                      - 
                      xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCCR_O_0003_0005)), 
                      '0.00'
                    )}
                    </ns3:amount>
                </ns3:totalAmountRepaid>
                <ns3:module>CON</ns3:module>
                <ns3:description>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0002)}</ns3:description>
                <ns3:partyName>{fn:data($CCCRResponse/ns1:user)}</ns3:partyName>
                <ns3:paymentType></ns3:paymentType>
                <ns3:tenure>
                {
                  let $startDate := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0005)
                  let $endDate := fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0006)
                  let $start := xs:date(concat(substring($startDate, 1, 4), '-', substring($startDate, 5, 2), '-', substring($startDate, 7, 2)))
                  let $end := xs:date(concat(substring($endDate, 1, 4), '-', substring($endDate, 5, 2), '-', substring($endDate, 7, 2)))
                  return days-from-duration($end - $start)
                }
                </ns3:tenure>
                <ns3:corpModule></ns3:corpModule>
                <ns3:linkages></ns3:linkages>
                <ns3:outstandingLoanDetailsDTO>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:refLinks></ns3:refLinks>
                    <ns3:accountId>
                        <ns3:displayValue>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCCR_O_0003_0001)}</ns3:displayValue>
                        <ns3:value>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCCR_O_0003_0001)}</ns3:value>
                    </ns3:accountId>
                    <ns3:principalBalance>
                        <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0012)),'0.00')}</ns3:amount>
                    </ns3:principalBalance>
                    <ns3:interestAmount>
                        <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0017)),'0.00')}</ns3:amount>
                    </ns3:interestAmount>
                    <ns3:penaltyInterestAmount></ns3:penaltyInterestAmount>
                    <ns3:prepaymentAmount></ns3:prepaymentAmount>
                    <ns3:outstandingAmount>
                        <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                        <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0013)),'0.00')}</ns3:amount>
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
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0016)),'0.00')}</ns3:amount>
                </ns3:principalOutstandingAmountLcy>
                <ns3:interestOutstandingAmountLcy>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0017)),'0.00')}</ns3:amount>
                </ns3:interestOutstandingAmountLcy>
                <ns3:totalOutstandingAmountLcy>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0013)),'0.00')}</ns3:amount>
                </ns3:totalOutstandingAmountLcy>
                <ns3:currencyCodeLcy>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currencyCodeLcy>
                <ns3:interestOutstandingAmount>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0017)),'0.00')}</ns3:amount>
                </ns3:interestOutstandingAmount>
                <ns3:totalOutstandingAmount>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0013)),'0.00')}</ns3:amount>
                </ns3:totalOutstandingAmount>
                <ns3:interestOSBalMaturity>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0017)),'0.00')}</ns3:amount>
                </ns3:interestOSBalMaturity>
                <ns3:totalOSBalMaturity>
                    <ns3:currency>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0014)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(xs:decimal(fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCRD/ns1:CCRD_O_0013)),'0.00')}</ns3:amount>
                </ns3:totalOSBalMaturity>
                <ns3:sortCode>{fn:data($CCCRResponse/ns1:operationData/ns1:CCCR_O_0003/ns1:CCCR_O_0003_0006)}</ns3:sortCode>
                <ns3:hostRelationshipCode></ns3:hostRelationshipCode>
                <ns3:relationshipType></ns3:relationshipType>
            </ns3:loanAccounts>
	    else()
            } -->
        </ns3:data>
    </ns3:LOAN_ACCOUNT_LISTResponse>
};

local:func($CCCRResponse, $CPFCResponse)