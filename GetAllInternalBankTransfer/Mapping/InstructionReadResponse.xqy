xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/instruction_read";
(:: import schema at "../XSD/INSTRUCTION_READ.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $userIdVariable as xs:string external;
declare variable $value as xs:string external;
declare variable $refNo as xs:string external;
declare variable $status as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$userIdVariable,$value,$refNo,$status) as element() (:: schema-element(ns2:Response) ::) {
                            let $errCode := fn:data($Response/*:errorCode) return
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}    </ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($Response/ns1:errorCode) = 'C') then 
                 (
          <ns2:errorList>
              <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
              <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
                         {
  for $tx in $Response/ns1:operationData/ns1:CTFI_O_0003
    where fn:data($tx/ns1:CTFI_O_0003_0001) = $refNo
  return    
            <ns2:instruction>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId>{ $userIdVariable }</ns2:partyId>               
                <ns2:externalReferenceNo>{fn:data($tx/ns1:CTFI_O_0003_0001)}</ns2:externalReferenceNo>
                <ns2:transactionType>INTERNALFT</ns2:transactionType>
<ns2:startDate>{
  concat(
    substring($tx/ns1:CTFI_O_0003_0008, 1, 4), "-", 
    substring($tx/ns1:CTFI_O_0003_0008, 5, 2), "-", 
    substring($tx/ns1:CTFI_O_0003_0008, 7, 2), 
    "T00:00:00"
  )
}</ns2:startDate>

<ns2:endDate>{
  concat(
    substring($tx/ns1:CTFI_O_0003_0009, 1, 4), "-", 
    substring($tx/ns1:CTFI_O_0003_0009, 5, 2), "-", 
    substring($tx/ns1:CTFI_O_0003_0009, 7, 2), 
    "T00:00:00"
  )
}</ns2:endDate>

<ns2:nextExecutionDate>{
  concat(
    substring($tx/ns1:CTFI_O_0003_0010, 1, 4), "-", 
    substring($tx/ns1:CTFI_O_0003_0010, 5, 2), "-", 
    substring($tx/ns1:CTFI_O_0003_0010, 7, 2), 
    "T00:00:00"
  )
}</ns2:nextExecutionDate>
                <ns2:instructionAmount>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:amount> {
              let $amount := xs:decimal(fn:data($tx/ns1:CTFI_O_0003_0005)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }</ns2:amount>
             </ns2:instructionAmount>
                <ns2:debitAccountId>{fn:data($tx/ns1:CTFI_O_0003_0002)}</ns2:debitAccountId>
                <ns2:branchId>{$value}</ns2:branchId>
                <ns2:creditAccountId>{fn:data($tx/ns1:CTFI_O_0003_0003)}</ns2:creditAccountId>
                <ns2:creditAccountBranchId>{$value}</ns2:creditAccountBranchId>
                <ns2:beneficiaryName>{fn:data($tx/ns1:CTFI_O_0003_0004)}</ns2:beneficiaryName>
                <ns2:remarks>{fn:data($tx/ns1:CTFI_O_0003_0007)}</ns2:remarks>
                <ns2:status>{
  let $status1 := normalize-space($tx/ns1:CTFI_O_0003_0012)
  return
    if ($status1 = 'Activa') then 'O'
    else if ($status1 = 'Anulada por utilizador') then 'C'
    else ' '
}</ns2:status>
                <ns2:purposeId>NULL</ns2:purposeId>
{
let $freq := fn:data($tx/ns1:CTFI_O_0003_0011)
let $endDate := fn:data($tx/ns1:CTFI_O_0003_0009)
let $year := xs:integer(substring($endDate, 1, 4))
let $month := xs:integer(substring($endDate, 5, 2))
let $lastDay := 
  if ($month = 1 or $month = 3 or $month = 5 or $month = 7 or $month = 8 or $month = 10 or $month = 12)
  then 31
  else if ($month = 4 or $month = 6 or $month = 9 or $month = 11)
  then 30
  else
    if (($year mod 400 = 0) or (($year mod 4 = 0) and ($year mod 100 != 0))) then 29
    else 28
return
  <frequency>
    <days>{
      if ($freq = 'Diaria') then '01'
      else if ($freq = 'Semanal') then '07'
      else if ($freq = 'Quinzenal') then '15'
      else '00'
    }</days>
    <months>{
      if ($freq = 'Mensal') then '01'
      else if ($freq = 'Bimestral') then '2'
      else if ($freq = 'Semestral') then '6'
      else if ($freq = 'Fim de mês') then '01'
      else if ($freq = 'Trimestral') then '03'
      else '00'
    }</months>
    <years>{if ($freq = 'Anual') then '01' else '00'}</years>
  </frequency>
}   <ns2:paymentDetailsList>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:valueDate></ns2:valueDate>
                    <ns2:status>{
  let $status1 := normalize-space($tx/ns1:CTFI_O_0003_0012)
  return
    if ($status1 = 'Activa') then 'O'
    else if ($status1 = 'Anulada por utilizador') then 'C'
    else ' '
}</ns2:status>
                    <ns2:failureReason></ns2:failureReason>
                </ns2:paymentDetailsList>
            </ns2:instruction>
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$userIdVariable,$value,$refNo,$status)