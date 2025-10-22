xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CMOV";
(:: import schema at "CMOV.xsd" ::)
declare namespace ns2="http://www.mozabank.org/casa_statement_item_list";
(:: import schema at "CASA_STATEMENT_ITEM_LIST.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";
declare variable $CMOVResponse as element() (:: schema-element(ns1:Response) ::) external;
declare variable $ObdxRequest as element() (:: schema-element(ns2:Request) ::) external;

declare function local:func($CMOVResponse as element() (:: schema-element(ns1:Response) ::), 
                            $ObdxRequest as element() (:: schema-element(ns2:Request) ::)) 
                            as element() (:: schema-element(ns2:Response) ::) {
  let $errCode := fn:data($CMOVResponse/ns1:errorCode)
  return
   <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>
                  { if($errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE' }
                </ns2:status>
                {
                  if ($errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                  else if(fn:data($CMOVResponse/ns1:errorCode) = 'C') then 
                  (
                    <ns2:errorList>
                      <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CMOVResponse/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns2:code>
                      <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CMOVResponse/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($CMOVResponse/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
                    </ns2:errorList>
                  )
                  else if ($errCode = '906' or $errCode = 'A') then 
                  (
                    <ns2:errorList>
                      <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns2:code>
                      <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', 'Invalid Backend Response') }</ns2:message>
                    </ns2:errorList>
                  )
                  else (
                    <ns2:errorList>
                      <ns2:code>ERR001</ns2:code>
                      <ns2:message>Invalid backend response</ns2:message>
                    </ns2:errorList>
                  )
                }
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
          {
            if($errCode = '0' or $errCode = 'P' or $errCode ='B') then
            (
              for $cmovResp in  $CMOVResponse/ns1:operationData/ns1:CMOV_O_0011
              return
              <ns2:statementItemList>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId>{fn:data($cmovResp/ns1:CMOV_O_0011_0018)}</ns2:externalReferenceId>
                <ns2:subSequenceNumber></ns2:subSequenceNumber>
                <ns2:postingDate>{let $dateString := fn:data($cmovResp/ns1:CMOV_O_0011_0001) return concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2),'T00:00:00')}</ns2:postingDate>
                <ns2:valueDate>{let $dateString := fn:data($cmovResp/ns1:CMOV_O_0011_0014) return concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2),'T00:00:00')}</ns2:valueDate>
                <ns2:transactionDate>{let $dateString := fn:data($cmovResp/ns1:CMOV_O_0011_0001) return concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2),'T00:00:00')}</ns2:transactionDate>
                <ns2:remarks>{fn:data($cmovResp/ns1:CMOV_O_0011_0005)}</ns2:remarks>
                <ns2:accountId>{fn:data($CMOVResponse/ns1:operationData/ns1:CMOV_O_0001)}</ns2:accountId>
                <ns2:amount>
                    <ns2:currency>{fn:data($cmovResp/ns1:CMOV_O_0011_0008)}</ns2:currency>
                  <ns2:amount>{fn-bea:format-number(fn:data($cmovResp/ns1:CMOV_O_0011_0006) div 100, '0.00')}</ns2:amount>
                </ns2:amount>
                <ns2:userReferenceNumber>{fn:data($cmovResp/ns1:CMOV_O_0011_0018)}</ns2:userReferenceNumber>
                <ns2:counterPartyAccountId> </ns2:counterPartyAccountId>
                <ns2:transactionType>
                {
                  let $value := fn:normalize-space($cmovResp/ns1:CMOV_O_0011_0007)
                  return
                    if ($value = '+') then 'C'
                    else if ($value = '-') then 'D'
                    else ''
                }
                </ns2:transactionType>
                <ns2:runningBalance>
                    <ns2:currency>{fn:data($cmovResp/ns1:CMOV_O_0011_0011)}</ns2:currency>
                <ns2:amount>{fn-bea:format-number(fn:data($cmovResp/ns1:CMOV_O_0011_0012) div 100, '0.00')}</ns2:amount>
                                    </ns2:runningBalance>
                <ns2:branchId>010</ns2:branchId>
             <ns2:toDate>
{
  let $fromDateStr := fn:normalize-space($ObdxRequest/ns2:fromDate)
  let $toDateStr   := fn:normalize-space($ObdxRequest/ns2:toDate)
  return
    if ($fromDateStr = '' and $toDateStr = '') then
      let $d := fn:current-date()
      return concat(
        substring(string($d), 1, 4), "-", 
        substring(string($d), 6, 2), "-", 
        substring(string($d), 9, 2), "T00:00:00"
      )
    else
      concat($toDateStr, "T00:00:00")
}
</ns2:toDate>
 
<ns2:fromDate>
{
  let $fromDateStr := fn:normalize-space($ObdxRequest/ns2:fromDate)
  let $toDateStr   := fn:normalize-space($ObdxRequest/ns2:toDate)
  return
    if ($fromDateStr = '' and $toDateStr = '') then
      let $d := fn:current-date()
      let $d14 := $d - xs:dayTimeDuration("P14D")
      return concat(
        substring(string($d14), 1, 4), "-", 
        substring(string($d14), 6, 2), "-", 
        substring(string($d14), 9, 2), "T00:00:00"
      )
    else
      let $orig := xs:date($toDateStr)
      let $prev := $orig - xs:dayTimeDuration("P1D")
      return concat(
        substring(string($prev), 1, 4), "-", 
        substring(string($prev), 6, 2), "-", 
        substring(string($prev), 9, 2), "T00:00:00"
      )
}
</ns2:fromDate>
 
                <ns2:creditDebitFlag>
                {
                  let $value := fn:normalize-space($cmovResp/ns1:CMOV_O_0011_0007)
                  return
                    if ($value = '+') then 'C'
                    else if ($value = '-') then 'D'
                    else ''
                }
                </ns2:creditDebitFlag>
              </ns2:statementItemList>
            )
            else ()
          }
        </ns2:data>
    </ns2:Response>
};

local:func($CMOVResponse, $ObdxRequest)