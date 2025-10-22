xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/MSB/TDProducts";
(:: import schema at "../Schema/GetProductTD_MSB.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_td_product_details";
(:: import schema at "../Schema/TD_PRODUCT_DETAILS.xsd" ::)
declare namespace dvm = "http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;


declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
 
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>SUCCESS</ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:product>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:accountType>TRD</ns2:accountType>
                <ns2:productId>{fn:data($Response/ns1:ID)}</ns2:productId>
                <ns2:productName>{fn:data($Response/ns1:DESCRICAO_COMPONENTE)}</ns2:productName>
                <ns2:productType>T</ns2:productType>
                <ns2:module></ns2:module>
                <ns2:startDate></ns2:startDate>
                <ns2:expiryDate></ns2:expiryDate>
                <ns2:tenure>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:minTenure>
                        <ns2:days>{fn:data($Response/ns1:PRAZO_MINIMO)}</ns2:days>
                        <ns2:months>0</ns2:months>
                        <ns2:years>0</ns2:years>
                    </ns2:minTenure>
                    <ns2:defaultTenure>
                        <ns2:days>{fn:data($Response/ns1:PRAZO_MAXIMO)}</ns2:days>
                        <ns2:months>0</ns2:months>
                        <ns2:years>0</ns2:years>
                    </ns2:defaultTenure>
                    <ns2:maxTenure>
                        <ns2:days>{fn:data($Response/ns1:PRAZO_MAXIMO)}</ns2:days>
                        <ns2:months>0</ns2:months>
                        <ns2:years>0</ns2:years>
                    </ns2:maxTenure>
                </ns2:tenure>
                <ns2:amount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:minAmount>
                        <ns2:currency>{fn:data($Response/ns1:MOEDA)}</ns2:currency>
<ns2:amount>{
    fn:round-half-to-even(
        xs:decimal(replace(fn:data($Response/ns1:VALOR_MINIMO), "[^0-9]", "")) div 100,
        2
    )
}</ns2:amount>
                    </ns2:minAmount>
                    <ns2:maxAmount>
                        <ns2:currency>{fn:data($Response/ns1:MOEDA)}</ns2:currency>
                       
                   <ns2:amount>{
    fn:round-half-to-even(
        xs:decimal(replace(fn:data($Response/ns1:VALOR_MAXIMO), "[^0-9]", "")) div 100,
        2
    )
}</ns2:amount>  </ns2:maxAmount> 

                    <ns2:currency>{fn:data($Response/ns1:MOEDA)}</ns2:currency>
                    <ns2:incrementStep></ns2:incrementStep>
                    <ns2:interestRate></ns2:interestRate>
                </ns2:amount>
                <ns2:isTopupAllowed>true</ns2:isTopupAllowed>
                <ns2:isPartialRedeemAllowed>true</ns2:isPartialRedeemAllowed>
                <ns2:accrualFrequency>M</ns2:accrualFrequency>
            </ns2:product>
        </ns2:data>
    </ns2:Response>
};

local:func($Response)