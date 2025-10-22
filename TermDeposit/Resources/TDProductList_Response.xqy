xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/obdx/td_product_list";
(:: import schema at "TD_PRODUCT_LIST.xsd" ::)
declare namespace ns1="http://www.mozabank.org/getTDProductDetails";
(:: import schema at "Schema/GetTDProductDetails.xsd" ::)

declare variable $Response_tdproductlist as element() (:: schema-element(ns1:ResponseList) ::) external;



declare function local:func($Response_tdproductlist as element() (:: schema-element(ns1:ResponseList) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>SUCCESS</ns2:status>
                 
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            {
            for $respList in $Response_tdproductlist/ns1:Response
            return
            <ns2:productList>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:accountType>TRD</ns2:accountType>
                <ns2:productId>{fn:data($respList/ns1:ID)}</ns2:productId>
                <ns2:productName>{ fn:data($respList/ns1:DESCRICAO_COMPONENTE)}</ns2:productName>
                <ns2:productType>SAVINGS</ns2:productType>
                <ns2:module>CON</ns2:module>
                <ns2:startDate></ns2:startDate>
                <ns2:expiryDate></ns2:expiryDate>
                <ns2:tenure>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:minTenure>
                        <ns2:days>{fn:data($respList/ns1:PRAZO_MAXIMO)}</ns2:days>
                        <ns2:months>0</ns2:months>
                        <ns2:years>0</ns2:years>
                    </ns2:minTenure>
                    <ns2:defaultTenure>
                        <ns2:days>{fn:data($respList/ns1:PRAZO_MAXIMO)}</ns2:days>
                        <ns2:months>0</ns2:months>
                        <ns2:years>0</ns2:years>
                    </ns2:defaultTenure>
                    <ns2:maxTenure>
                        <ns2:days>{fn:data($respList/ns1:PRAZO_MAXIMO)}</ns2:days>
                        <ns2:months>0</ns2:months>
                        <ns2:years>0</ns2:years>
                    </ns2:maxTenure>
                </ns2:tenure>
                <ns2:amount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:minAmount>
                        <ns2:currency>{fn:data($respList/ns1:MOEDA)}</ns2:currency>
                        <ns2:amount>{
                          fn-bea:format-number(
                            xs:decimal(
                              replace(fn:data($respList/ns1:VALOR_MINIMO), "[^0-9]", "")
                            ) div 100,
                            '0.00'
                          )
                        }</ns2:amount>
                    </ns2:minAmount>
                    <ns2:maxAmount>
                        <ns2:currency>{fn:data($respList/ns1:MOEDA)}</ns2:currency>
                        <ns2:amount>{
                          fn-bea:format-number(
                            xs:decimal(
                              replace(fn:data($respList/ns1:VALOR_MAXIMO), "[^0-9]", "")
                            ) div 100,
                            '0.00'
                          )
                        }</ns2:amount>
                    </ns2:maxAmount>
                    <ns2:currency>{fn:data($respList/ns1:MOEDA)}</ns2:currency>
                    <ns2:incrementStep></ns2:incrementStep>
                    <ns2:interestRate>
                        <ns2:dictionaryArray></ns2:dictionaryArray>
                        <ns2:slabs>
                            <ns2:dictionaryArray></ns2:dictionaryArray>
                            <ns2:amount>
                                <ns2:currency>{fn:data($respList/ns1:MOEDA)}</ns2:currency>
                                <ns2:amount>0.00</ns2:amount>
                            </ns2:amount>
                           <!-- <ns2:interestSlabRates>{fn:data($respList/ns1:TAXA_JURO)}</ns2:interestSlabRates> -->
                             <ns2:interestSlabRates></ns2:interestSlabRates> 
                        </ns2:slabs>
                    </ns2:interestRate>
                </ns2:amount>
                <ns2:isTopupAllowed>true</ns2:isTopupAllowed>
                <ns2:isPartialRedeemAllowed>true</ns2:isPartialRedeemAllowed>
                <ns2:accrualFrequency>M</ns2:accrualFrequency>
            </ns2:productList>
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response_tdproductlist)