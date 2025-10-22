xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_td_product_details";
(:: import schema at "../Schema/TD_PRODUCT_DETAILS.xsd" ::)

declare variable $CAPD_Response as element() (:: schema-element(ns1:CAPDResponse) ::) external;
declare variable $CCAP_Response as element() (:: schema-element(ns2:Response) ::) external;

declare function local:func($CAPD_Response as element() (:: schema-element(ns1:CAPDResponse) ::) (:: schema-element(ns2:Response) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>
                {
                  if (fn:data($CAPD_Response/ns1:errorCode) = 0) 
                  then 'SUCCESS' 
                  else 'FAILURE'
                }
                </ns3:status>
                {
                if(fn:data($CAPD_Response/ns1:errorCode) = 0) then () else(
                <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>) 
                } 
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            <ns3:product>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:accountType>TRD</ns3:accountType>
                <ns3:productId>002</ns3:productId>
                <ns3:productName>TD Product</ns3:productName>
                <ns3:productType>T</ns3:productType>
                <ns3:module></ns3:module>
                <ns3:startDate>
                {let $date := fn:data($CAPD_Response/ns1:operationData/ns1:CAPD_O_0005) return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:startDate>
                <ns3:expiryDate>
                {let $date := fn:data($CAPD_Response/ns1:operationData/ns1:CAPD_O_0006) return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:expiryDate>
                <ns3:tenure>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:minTenure>
                        <ns3:days>0</ns3:days>
                        <ns3:months>1</ns3:months>
                        <ns3:years>0</ns3:years>
                    </ns3:minTenure>
                    <ns3:defaultTenure>
                        <ns3:days>0</ns3:days>
                        <ns3:months>6</ns3:months>
                        <ns3:years>0</ns3:years>
                    </ns3:defaultTenure>
                    <ns3:maxTenure>
                        <ns3:days>0</ns3:days>
                        <ns3:months>0</ns3:months>
                        <ns3:years>2</ns3:years>
                    </ns3:maxTenure>
                </ns3:tenure>
                <ns3:amount>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:minAmount>
                        <ns3:currency>{fn:data($CAPD_Response/ns1:operationData/ns1:CAPD_O_0009)}</ns3:currency>
                        <ns3:amount>0.00</ns3:amount>
                    </ns3:minAmount>
                    <ns3:maxAmount>
                        <ns3:currency>{fn:data($CAPD_Response/ns1:operationData/ns1:CAPD_O_0009)}</ns3:currency>
                        <ns3:amount>999999</ns3:amount>
                    </ns3:maxAmount>
                    <ns3:currency>{fn:data($CAPD_Response/ns1:operationData/ns1:CAPD_O_0009)}</ns3:currency>
                    <ns3:incrementStep></ns3:incrementStep>
                    <ns3:interestRate></ns3:interestRate>
                </ns3:amount>
                <ns3:isTopupAllowed>true</ns3:isTopupAllowed>
                <ns3:isPartialRedeemAllowed>true</ns3:isPartialRedeemAllowed>
                <ns3:accrualFrequency>M</ns3:accrualFrequency>
            </ns3:product>
        </ns3:data>
    </ns3:Response>
};

local:func($CAPD_Response)