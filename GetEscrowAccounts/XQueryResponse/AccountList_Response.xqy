xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/cccc";
(:: import schema at "../MSB_Schema/CCCC.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCC_ACCOUNTS_LIST";
(:: import schema at "../OBDX_Schema/CCC_ACCOUNTS_LIST.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
           <ns2:status>
              {
                if (fn:data($Response/ns1:errorCode) = '0')
                then 'SUCCESS'
                else 'FAILURE'
              }
            </ns2:status>
            
            {
              if (fn:data($Response/ns1:errorCode) != '0') then (
                <ns2:errorList>
                  <ns2:code>ERR001</ns2:code>
                  <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>
              ) else ()
            }

            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        <ns2:accounts>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId>{fn:data($Response/ns1:user)}</ns2:partyId>
                <ns2:accountId>{fn:data($Response/ns1:operationData/ns1:CCCC_O_0003/ns1:CCCC_O_0003_0001)}</ns2:accountId>
              <ns2:nextInterestDebitDate>
{
  let $date := fn:data($Response/ns1:operationData/ns1:CCCC_O_0003/ns1:CCCC_O_0003_0004)
  return 
    if ($date != '') then 
      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
    else 
      ()
}
</ns2:nextInterestDebitDate>

                <ns2:accountingBalance>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CCCC_O_0003/ns1:CCCC_O_0003_0006)}</ns2:currency>
                    <ns2:amount>
  { fn-bea:format-number((xs:decimal(fn:data($Response/ns1:operationData/ns1:CCCC_O_0003/ns1:CCCC_O_0003_0007)) div 100), '0.00') }
</ns2:amount>



                </ns2:accountingBalance>
        </ns2:accounts>
        </ns2:data>
    </ns2:Response>
};

local:func($Response)