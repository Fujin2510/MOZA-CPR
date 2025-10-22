xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns2="http://www.mozabank.org/LOAN_ACCOUNT_LIST";
(:: import schema at "Schema/LOAN_ACCOUNT_LIST.xsd" ::)

declare variable $Response-cpfc as element() (:: schema-element(ns1:CPFCResponse) ::) external;

declare function local:func($Response-cpfc as element() (:: schema-element(ns1:CPFCResponse) ::)) as element() (:: schema-element(ns2:LOAN_ACCOUNT_LISTResponse) ::) {
    <ns2:LOAN_ACCOUNT_LISTResponse>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status></ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:loanAccounts>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId></ns2:partyId>
                <ns2:accountId></ns2:accountId>
                <ns2:branchId></ns2:branchId>
                <ns2:productId></ns2:productId>
                <ns2:status></ns2:status>
                <ns2:accountOpeningDate></ns2:accountOpeningDate>
                <ns2:term>
                    <ns2:days></ns2:days>
                    <ns2:months></ns2:months>
                    <ns2:years></ns2:years>
                </ns2:term>
                <ns2:sanctionedAmount>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:sanctionedAmount>
                <ns2:disbursedAmount>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:disbursedAmount>
                <ns2:currency></ns2:currency>
                <ns2:closureDate></ns2:closureDate>
                <ns2:penaltyRate></ns2:penaltyRate>
                <ns2:prepaymentPenaltyRate></ns2:prepaymentPenaltyRate>
                <ns2:noOfLinkage></ns2:noOfLinkage>
                <ns2:firstDisbursementDate>
                {let $date := fn:data($Response-cpfc/ns1:operationData/ns1:CPFC_O_0003/ns1:CPFC_O_0003_0006)
                return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns2:firstDisbursementDate>
                <ns2:lastDisbursementDate>
                {let $date := fn:data($Response-cpfc/ns1:operationData/ns1:CPFC_O_0003/ns1:CPFC_O_0003_0006)
                return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns2:lastDisbursementDate>
                <ns2:interestRate></ns2:interestRate>
                <ns2:maturityDate></ns2:maturityDate>
                <ns2:noOfInstallments></ns2:noOfInstallments>
                <ns2:outstandingAmount>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:outstandingAmount>
                <ns2:totalAmountRepaid>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:totalAmountRepaid>
                <ns2:module></ns2:module>
                <ns2:description></ns2:description>
                <ns2:partyName></ns2:partyName>
                <ns2:paymentType></ns2:paymentType>
                <ns2:tenure></ns2:tenure>
                <ns2:corpModule></ns2:corpModule>
                <ns2:linkages></ns2:linkages>
                <ns2:outstandingLoanDetailsDTO>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:refLinks></ns2:refLinks>
                    <ns2:accountId>
                        <ns2:displayValue></ns2:displayValue>
                        <ns2:value></ns2:value>
                    </ns2:accountId>
                    <ns2:principalBalance>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:principalBalance>
                    <ns2:interestAmount>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:interestAmount>
                    <ns2:penaltyInterestAmount></ns2:penaltyInterestAmount>
                    <ns2:prepaymentAmount></ns2:prepaymentAmount>
                    <ns2:outstandingAmount>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:outstandingAmount>
                    <ns2:serviceCharges></ns2:serviceCharges>
                    <ns2:installmentArrear></ns2:installmentArrear>
                    <ns2:prepaymentPenaltyAmount></ns2:prepaymentPenaltyAmount>
                    <ns2:penaltyAmount></ns2:penaltyAmount>
                    <ns2:lateRepaymentCharges></ns2:lateRepaymentCharges>
                    <ns2:repaymentAmount></ns2:repaymentAmount>
                    <ns2:component></ns2:component>
                    <ns2:componentName></ns2:componentName>
                    <ns2:amountPaid></ns2:amountPaid>
                    <ns2:amountDue></ns2:amountDue>
                    <ns2:recomputationBasis></ns2:recomputationBasis>
                    <ns2:interestArrears></ns2:interestArrears>
                    <ns2:principalArrears></ns2:principalArrears>
                </ns2:outstandingLoanDetailsDTO>
                <ns2:principalOutstandingAmountLcy>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:principalOutstandingAmountLcy>
                <ns2:interestOutstandingAmountLcy>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:interestOutstandingAmountLcy>
                <ns2:totalOutstandingAmountLcy>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:totalOutstandingAmountLcy>
                <ns2:currencyCodeLcy></ns2:currencyCodeLcy>
                <ns2:interestOutstandingAmount>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:interestOutstandingAmount>
                <ns2:totalOutstandingAmount>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:totalOutstandingAmount>
                <ns2:interestOSBalMaturity>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:interestOSBalMaturity>
                <ns2:totalOSBalMaturity>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:totalOSBalMaturity>
                <ns2:sortCode></ns2:sortCode>
                <ns2:hostRelationshipCode></ns2:hostRelationshipCode>
                <ns2:relationshipType></ns2:relationshipType>
                <ns2:amountDue></ns2:amountDue>
            </ns2:loanAccounts>
        </ns2:data>
    </ns2:LOAN_ACCOUNT_LISTResponse>
};

local:func($Response-cpfc)