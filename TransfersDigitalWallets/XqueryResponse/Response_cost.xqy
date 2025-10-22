xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/DW_TFCM_TXN_COST";
(:: import schema at "../XSD/dw_tfcm_txn_cost.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:getTransactionCostResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:getTransactionCostResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
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
            <ns2:amount></ns2:amount>
            <ns2:transactionCost></ns2:transactionCost>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)