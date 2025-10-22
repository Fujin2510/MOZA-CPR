xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cdod";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns3="http://www.mozabanca.org/obdx/instruction_list";
(:: import schema at "../XSD/INSTRUCTION_LIST.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CDODResponse as element() (:: schema-element(ns2:Response) ::) external;
declare variable $userIdVariable as xs:string external;
declare variable $refNo as xs:string external;
declare variable $status as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::), 
                            $CDODResponse as element() (:: schema-element(ns2:Response) ::),$userIdVariable,$refNo,$status) 
                            as element() (:: schema-element(ns3:Response) ::) {
                            let $errCode := fn:data($Response/*:errorCode) return
     <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
           <ns3:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}    </ns3:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($Response/ns1:errorCode) = 'C') then 
                 (
          <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns3:message>
          </ns3:errorList>)
                 else if($errCode = '906' or $errCode = 'A') then 
                (
            <ns3:errorList>
                <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns3:code>
                <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns3:message>
            </ns3:errorList>)
       else(
            <ns3:errorList>
                <ns3:code>ERR001</ns3:code>
                <ns3:message>Invalid backend response</ns3:message>
            </ns3:errorList>)
                                    }
            <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
                 {
  for $tx in $Response/ns1:operationData/ns1:CTFI_O_0003
  where (
  fn:normalize-space($refNo) = '' 
  or fn:data($tx/ns1:CTFI_O_0003_0001) = $refNo
)
  return
            <ns3:instructions>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{ $userIdVariable }</ns3:partyId>
                <ns3:externalReferenceNo>{fn:data($tx/ns1:CTFI_O_0003_0001)}</ns3:externalReferenceNo>
                <ns3:transactionType>INTERNALFT</ns3:transactionType>
<ns3:startDate>{
  concat(
    substring($tx/ns1:CTFI_O_0003_0008, 1, 4), "-", 
    substring($tx/ns1:CTFI_O_0003_0008, 5, 2), "-", 
    substring($tx/ns1:CTFI_O_0003_0008, 7, 2), 
    "T00:00:00"
  )
}</ns3:startDate>

<ns3:endDate>{
  concat(
    substring($tx/ns1:CTFI_O_0003_0009, 1, 4), "-", 
    substring($tx/ns1:CTFI_O_0003_0009, 5, 2), "-", 
    substring($tx/ns1:CTFI_O_0003_0009, 7, 2), 
    "T00:00:00"
  )
}</ns3:endDate>

<ns3:nextExecutionDate>{
  concat(
    substring($tx/ns1:CTFI_O_0003_0010, 1, 4), "-", 
    substring($tx/ns1:CTFI_O_0003_0010, 5, 2), "-", 
    substring($tx/ns1:CTFI_O_0003_0010, 7, 2), 
    "T00:00:00"
  )
}</ns3:nextExecutionDate>
                <ns3:instructionAmount>
                    <ns3:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns3:currency>
<ns3:amount>
  {
              let $amount := xs:decimal(fn:data($tx/ns1:CTFI_O_0003_0005)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }
</ns3:amount>
                </ns3:instructionAmount>
                <ns3:debitAccountId>{fn:data($tx/ns1:CTFI_O_0003_0002)}</ns3:debitAccountId>
                <ns3:branchId>{fn:data($CDODResponse/ns2:operationData/ns2:CDOD_O_0003)}</ns3:branchId>
                <ns3:creditAccountId>{fn:data($tx/ns1:CTFI_O_0003_0003)}</ns3:creditAccountId>
                <ns3:creditAccountBranchId>{fn:data($CDODResponse/ns2:operationData/ns2:CDOD_O_0003)}</ns3:creditAccountBranchId>
                <ns3:beneficiaryName>{fn:data($tx/ns1:CTFI_O_0003_0004)}</ns3:beneficiaryName>
                <ns3:remarks>{fn:data($tx/ns1:CTFI_O_0003_0007)}</ns3:remarks>
      <ns3:status>{
  let $status1 := normalize-space($tx/ns1:CTFI_O_0003_0012)
  return
    if ($status1 = 'Activa') then 'O'
    else if ($status1 = 'Anulada por utilizador') then 'C'
    else ' '
}</ns3:status>
                <ns3:purposeId>NULL</ns3:purposeId>
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
}
  <ns3:paymentDetailsList>
                    <ns3:dictionaryArray></ns3:dictionaryArray>
                    <ns3:valueDate></ns3:valueDate>
      <ns3:status>{
  let $status1 := normalize-space($tx/ns1:CTFI_O_0003_0012)
  return
    if ($status1 = 'Activa') then 'O'
    else if ($status1 = 'Anulada por utilizador') then 'C'
    else ' '
}</ns3:status>
                    <ns3:failureReason>{fn:data($tx/ns1:CTFI_O_0003_0012)}</ns3:failureReason>
                </ns3:paymentDetailsList>
            </ns3:instructions>
            }
        </ns3:data>
    </ns3:Response>
};

local:func($Response, $CDODResponse,$userIdVariable,$refNo,$status)