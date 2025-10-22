xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "LoanFetch/Schema/CCCR-CCRD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/LoanOutstandingDetails";
(:: import schema at "LOAN_OUTSTANDING_DETAILS.xsd" ::)
declare variable $loanAccountVar as xs:string external;
declare variable $ResponseLod as element() (:: schema-element(ns1:CCCRResponse) ::) external;

declare function local:func($ResponseLod as element() (:: schema-element(ns1:CCCRResponse) ::),$loanAccountVar) as element() (:: schema-element(ns2:LOAN_OUTSTANDING_DETAILSResponse) ::) {
  let $cccr := $ResponseLod/ns1:operationData/ns1:CCCR_O_0003[ns1:CCCR_O_0003_0001 = $loanAccountVar] 
  return
    <ns2:LOAN_OUTSTANDING_DETAILSResponse>
        <ns2:data>
          <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{if (fn:data($ResponseLod/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {if(fn:data($ResponseLod/ns1:errorCode) = '0') then () else(
                <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>) } 
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:accountId>{fn:data($cccr/ns1:CCCR_O_0003_0001)}</ns2:accountId>
            <ns2:branchId>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0002)}</ns2:branchId>
            <ns2:principalBalance>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012), '0.00')}</ns2:amount>
                
            </ns2:principalBalance>
            <ns2:penaltyInterestAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:penaltyInterestAmount>
            <ns2:prepaymentAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:prepaymentAmount>
            <ns2:outstandingAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:outstandingAmount>
            <ns2:serviceCharges>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:serviceCharges>
            <ns2:installmentArrear>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>
                {fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0017), '0.00')}
                </ns2:amount>
            </ns2:installmentArrear>
            <ns2:prepaymentPenaltyAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:prepaymentPenaltyAmount>
            <ns2:lateRepaymentCharges>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:lateRepaymentCharges>
            <ns2:interestArrears>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:interestArrears>
            <ns2:principalArrears>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:principalArrears>
            <ns2:penaltyAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>0.00</ns2:amount>
            </ns2:penaltyAmount>
            <ns2:interestAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0017), '0.00')}</ns2:amount>
            </ns2:interestAmount>
            <ns2:repaymentAmount>
                <ns2:currency>{fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0014)}</ns2:currency>
                <ns2:amount>{fn-bea:format-number(fn:data($cccr/ns1:CCRD/ns1:CCRD_O_0012), '0.00')}</ns2:amount>
            </ns2:repaymentAmount>
            <ns2:recomputationBasis></ns2:recomputationBasis>
        </ns2:data>
    </ns2:LOAN_OUTSTANDING_DETAILSResponse>
};

local:func($ResponseLod,$loanAccountVar)