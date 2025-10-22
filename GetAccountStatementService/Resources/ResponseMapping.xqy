xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CASAStatementItemList";
(:: import schema at "CASAStatementItemList.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CMOV";
(:: import schema at "CMOV.xsd" ::)

declare variable $CMOVResponse as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($CMOVResponse as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:result>
                <ns2:status></ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
                <ns2:externalReferenceId></ns2:externalReferenceId>
            </ns2:result>
            <ns2:statementItemList>
                <ns2:externalReferenceId>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0018)}</ns2:externalReferenceId>
                <ns2:subSequenceNumber>001</ns2:subSequenceNumber>
                <ns2:postingDate>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0001)}</ns2:postingDate>
                <ns2:valueDate>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0014)}</ns2:valueDate>
                <ns2:transactionDate>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0001)}</ns2:transactionDate>
                <ns2:remarks></ns2:remarks>
                <ns2:accountId>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0001)}</ns2:accountId>
                <ns2:amount>
                    <ns2:currency></ns2:currency>
                    <ns2:amount>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0006)}</ns2:amount>
                </ns2:amount>
                <ns2:userReferenceNumber>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0018)}</ns2:userReferenceNumber>
                <ns2:counterPartyAccountId></ns2:counterPartyAccountId>
                <ns2:transactionType>{ let $value1 :=  fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0007) return if ( $value1 = '+' ) then 'C' else if ( $value1 = '-' ) then 'D' else () }</ns2:transactionType>
                <ns2:runningBalance>
                    <ns2:currency></ns2:currency>
                    <ns2:amount>{fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0012)}</ns2:amount>
                </ns2:runningBalance>
                <ns2:branchId></ns2:branchId>
                <ns2:toDate></ns2:toDate>
                <ns2:fromDate></ns2:fromDate>
                <ns2:creditDebitFlag>{ let $value2 :=  fn:data($CMOVResponse/ns1:data/ns1:operationData/ns1:CMOV_O_0011/ns1:CMOV_O_0011_0007) return if ( $value2 = '+' ) then 'C' else if ( $value2 = '-' ) then 'D' else () }</ns2:creditDebitFlag>
            </ns2:statementItemList>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
        </ns2:data>
    </ns2:Response>
};

local:func($CMOVResponse)