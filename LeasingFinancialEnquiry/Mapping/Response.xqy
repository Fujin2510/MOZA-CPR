xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabanca.org/CPFL";
(:: import schema at "../XSDs/CPFL.xsd" ::)
declare namespace ns2 = "http://www.mozabanca.org/LSI";
(:: import schema at "../XSDs/LEASE_SCHEDULE_INQUIRY.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $MSB_Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($MSB_Response /*:errorCode) return
  <ns2:Response>
    <ns2:data>
      <ns2:dictionaryArray/>
      <ns2:referenceNo/>
      <ns2:result>
        <ns2:dictionaryArray/>
        <ns2:externalReferenceId/>
                <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>

                {

                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()

                 else if(fn:data($MSB_Response /ns1:errorCode) = 'C') then 

                 (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($MSB_Response /*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($MSB_Response /*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
</ns2:errorList>)

                 else if($errCode = '906' or $errCode = 'A') then 

                (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
</ns2:errorList>)

                 else(
<ns2:errorList>
<ns2:code>ERR001</ns2:code>
<ns2:message>Invalid backend response</ns2:message>
</ns2:errorList>)

			}
        <ns2:warningList/>
      </ns2:result>
      <ns2:hasMore/>
      <ns2:totalRecords/>
      <ns2:startSequence/>

      {
     if($errCode = '0') then 
        for $item at $i in $MSB_Response/ns1:operationData/ns1:CPFL_O_0003
        return
          <ns2:statementItemList>
            <ns2:dictionaryArray/>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:subSequenceNumber>{
              if ($i lt 10) then concat("00", $i)
              else if ($i lt 100) then concat("0", $i)
              else string($i)
            }</ns2:subSequenceNumber>
           <ns2:installmentDueDate>{
                let $raw := fn:normalize-space(fn:data($item/ns1:CPFL_O_0003_0006))
                return
                  if (string-length($raw) = 8) then
                    concat(substring($raw, 1, 4), '-', substring($raw, 5, 2), '-', substring($raw, 7, 2), 'T00:00:00')
                  else ""
              }</ns2:installmentDueDate>
              <ns2:statusDate>{
                let $raw := fn:normalize-space(fn:data($item/ns1:CPFL_O_0003_0008))
                return
                  if (string-length($raw) = 8) then
                    concat(substring($raw, 1, 4), '-', substring($raw, 5, 2), '-', substring($raw, 7, 2), 'T00:00:00')
                  else ""
              }</ns2:statusDate>
              <ns2:typeOfTransaction>{
                let $code := fn:data($item/ns1:CPFL_O_0003_0001)
                return
                  if ($code = 'A') then 'Amortization'
                  else if ($code = 'J') then 'Interests'
                  else if ($code = 'R') then 'Rent'
                  else if ($code = 'U') then 'Use of Capital'
                  else ''
              }</ns2:typeOfTransaction>
              <ns2:installmentNumber>{fn:data($item/ns1:CPFL_O_0003_0002)}</ns2:installmentNumber>
              <ns2:installmentAmount>
                <ns2:currency>MZN</ns2:currency>
                <ns2:amount>{
                  let $raw := fn:normalize-space(fn:data($item/ns1:CPFL_O_0003_0003))
                  return if ($raw castable as xs:decimal) then
                    fn:string(xs:decimal($raw) div 100)
                  else
                    "0.00"
                }</ns2:amount>
              </ns2:installmentAmount>
              <ns2:amountInDebt>
                <ns2:currency>MZN</ns2:currency>
                <ns2:amount>{
                  let $raw := fn:normalize-space(fn:data($item/ns1:CPFL_O_0003_0005))
                  return if ($raw castable as xs:decimal) then
                    fn:string(xs:decimal($raw) div 100)
                  else
                    "0.00"
                }</ns2:amount>
              </ns2:amountInDebt>
              <ns2:interest>{
                let $raw := fn:normalize-space(fn:data($item/ns1:CPFL_O_0003_0004))
                return if ($raw castable as xs:decimal) then
                  fn:string(xs:decimal($raw) div 100)
                else
                  "0.00"
              }</ns2:interest>
              <ns2:status>{fn:data($item/ns1:CPFL_O_0003_0007)}</ns2:status>
          </ns2:statementItemList>
else()
      }
    </ns2:data>
  </ns2:Response>
};

local:func($MSB_Response)