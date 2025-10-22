xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/hiop";
(:: import schema at "../XSD/HIOP.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/cz_outward_remittance_list";
(:: import schema at "../XSD/CZ_OUTWARD_REMITTANCE_LIST.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userId as xs:string external;
declare variable $pageNo as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::), 
                            $Request as element() (:: schema-element(ns1:Request) ::),$userId,$pageNo) 
                            as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($Response/*:errorCode) 
(: --- Paging controls --- :)
let $pageSize := 10
let $page :=
  if (normalize-space($pageNo) castable as xs:integer and xs:integer($pageNo) > 0)
  then xs:integer($pageNo)
  else 1

let $allRecords :=
  for $tx in $Response/ns1:operationData/ns1:HIOP_O_0003
  order by 
    $tx/ns1:HIOP_O_0003_0001 descending,
    $tx/ns1:HIOP_O_0003_0005 descending
  return $tx

let $totalRecords := count($allRecords)
let $maxPage      := ceiling($totalRecords div $pageSize)

(: start/end for NON-cumulative page :)
let $start := (($page - 1) * $pageSize) + 1
let $requestedEnd := $page * $pageSize
let $finalEnd :=
  if ($requestedEnd gt $totalRecords) then $totalRecords else $requestedEnd

(: if page beyond range -> no records :)
let $pagedRecords :=
  if ($page gt $maxPage) then ()
  else
    for $tx at $pos in $allRecords
    where $pos ge $start and $pos le $finalEnd
    return $tx

let $hasMore := if ($finalEnd lt $totalRecords) then 'true' else 'false'

return

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
            <ns2:totalRecords>{
              count($Response/ns1:operationData/ns1:HIOP_O_0003)
            }</ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
             {
  for $tx in $pagedRecords
return
            <ns2:outwardremittances>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId>{$userId}</ns2:partyId>
                <ns2:paymentDate>
                { concat(
                    substring($tx/ns1:HIOP_O_0003_0001, 1, 4), "-", 
                    substring($tx/ns1:HIOP_O_0003_0001, 5, 2), "-", 
                    substring($tx/ns1:HIOP_O_0003_0001, 7, 2), 
                    "T",
                      substring($tx/ns1:HIOP_O_0003_0002, 1, 2), ":", 
                      substring($tx/ns1:HIOP_O_0003_0002, 3, 2), ":", 
                      substring($tx/ns1:HIOP_O_0003_0002, 5, 2)
                  )}</ns2:paymentDate>     
               <ns2:purposeId></ns2:purposeId>                   
                <ns2:remarks></ns2:remarks>
                <ns2:bankCharges></ns2:bankCharges>
                <ns2:exchangeRate></ns2:exchangeRate>
                <ns2:transactionAmount>
                 <ns2:currency>{
                  let $msg := fn:data($tx/ns1:HIOP_O_0003_0006)
                  return
                    if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFI') then substring($msg, 44, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PASI') then substring($msg, 86, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'TFCM') then substring($msg, 16, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PAGS') then substring($msg, 42, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'INSS') then substring($msg, 16, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFZ') then if (contains($msg, 'MZN')) then 'MZN' else ()
                   else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'CORO') then substring($msg, 16, 3)
                      else ()
                }</ns2:currency>
                <ns2:amount>{
                  let $msg := fn:data($tx/ns1:HIOP_O_0003_0006)
                  let $type := fn:data($tx/ns1:HIOP_O_0003_0003)
                  return   
                     if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFI') then
                     let $rawAmount := substring($msg, 29, 15)
                     return xs:integer($rawAmount) div 100
                
                    else if ($type = 'PASI') then
                        let $rawAmount := substring($msg, 71, 15)
                      return xs:integer($rawAmount) div 100
                      
                    else if ($type = 'TFCM') then
                        let $rawAmount := substring($msg, 1, 15)
                    return xs:integer($rawAmount) div 100
                
                    else if ($type = 'PAGS') then
                      let $rawAmount := substring($msg, 29, 13)
                      return xs:integer($rawAmount) div 100
                
                    else if ($type = 'INSS') then
                    let $rawAmount := substring($msg, 1, 15)
                      return xs:integer($rawAmount) div 100
                      
                    else if ($type = 'PTFZ') then
                      let $currencyPos := string-length(substring-before($msg, 'MZN')) + 1
                      let $amountStart := $currencyPos - 15
                      let $rawAmount := substring($msg, $amountStart, 15)
                      return xs:integer($rawAmount) div 100
                      
                     else if ($type = 'CORO') then
                    let $rawAmount := substring($msg, 1, 15)
                    return xs:integer($rawAmount) div 100         
                    else ()
                }</ns2:amount>                             
                </ns2:transactionAmount>
                <ns2:debitAccount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                     <ns2:accountId>{
                        let $msg := fn:data($tx/ns1:HIOP_O_0003_0006)
                        return
                          if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFI') then substring($msg, 1, 14)
                          else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PASI') then substring($msg, 1, 14)
                          else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'TFCM') then substring($msg, 19, 14)
                          else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PAGS') then substring($msg, 1, 14)
                          else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'INSS') then substring($msg, 19, 14)
                          else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFZ') then
                            let $currencyPos := string-length(substring-before($msg, 'MZN')) + 1
                            let $amountStart := $currencyPos - 15
                            let $accountNumber := substring($msg, 1, $amountStart - 1)
                            return $accountNumber
                         else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'CORO') then substring($msg, 19, 14)
                            else ()
                         }</ns2:accountId>
                    <ns2:currency></ns2:currency>
                    <ns2:bankCode></ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:iban></ns2:iban>
                </ns2:debitAccount>                                                      
                <ns2:creditAccount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
              <ns2:accountId>{
  let $msg := fn:data($tx/ns1:HIOP_O_0003_0006)
  let $type := fn:data($tx/ns1:HIOP_O_0003_0003)
  return
    if ($type = 'PTFI') then 
      substring($msg, 15, 14)
    else if ($type = 'PTFZ') then 
      let $pos := string-length(substring-before($msg, 'MZN')) + 4
      return substring($msg, $pos, 21)
    else ()
}</ns2:accountId>
                    <ns2:currency></ns2:currency>
                    <ns2:bankCode></ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:iban></ns2:iban>
                </ns2:creditAccount>
                <ns2:txnReferenceId>{fn:data($tx/ns1:HIOP_O_0003_0005)}</ns2:txnReferenceId>
                  <ns2:paymentStatus>{
                    let $val := fn:data($tx/ns1:HIOP_O_0003_0004)
                    return
                      if ($val = 'T') then 'S'
                      else if ($val = 'P') then 'P'
                      else if ($val = 'C') then 'C'
                      else if ($val = 'I') then 'Z'
                      else $val
                  }</ns2:paymentStatus>
                  <ns2:paymentType>{fn:data($tx/ns1:HIOP_O_0003_0003)}</ns2:paymentType>
                <ns2:receiptBase64></ns2:receiptBase64>
  {
  let $msg      := fn:data($tx/ns1:HIOP_O_0003_0006)
  let $fundType := fn:data($tx/ns1:HIOP_O_0003_0003)
  let $hiop001  := fn:data($tx/ns1:HIOP_O_0003_0001)
 
  let $rawDateCandidate :=
    if ($fundType = ('PASI','PTFI','PAGS','PTFZ')) then
      let $trimmedMsg := normalize-space($msg)
      let $last8      := substring($trimmedMsg, string-length($trimmedMsg) - 7, 8)
      return
        if (string-length($trimmedMsg) >= 8
            and matches($last8, '^\d{8}$')
            and $last8 != '00000000')          (: <-- reject all zeros :)
        then $last8
        else if (matches($hiop001, '^\d{8}$'))
             then $hiop001
             else ()
    else ()
 
  let $formattedDate :=
    if ($rawDateCandidate != '') then
      concat(
        substring($rawDateCandidate, 1, 4), "-",
        substring($rawDateCandidate, 5, 2), "-",
        substring($rawDateCandidate, 7, 2), "T00:00:00"
      )
    else ()
 
  return
    if ($fundType = ('PASI','PTFI','PAGS','PTFZ')) then
      (
<ns2:fundReceivedDate>{$formattedDate}</ns2:fundReceivedDate>,
<ns2:fundCreditedDate>{$formattedDate}</ns2:fundCreditedDate>
      )
    else
      (
<ns2:fundReceivedDate/>,
<ns2:fundCreditedDate/>
      )
}
                <ns2:orderingPartyId></ns2:orderingPartyId>
                <ns2:debitAmount>
                <ns2:currency>{
                  let $msg := fn:data($tx/ns1:HIOP_O_0003_0006)
                  return
                    if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFI') then substring($msg, 44, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PASI') then substring($msg, 86, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'TFCM') then substring($msg, 16, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PAGS') then substring($msg, 42, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'INSS') then substring($msg, 16, 3)
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFZ') then if (contains($msg, 'MZN')) then 'MZN' else ()
                    else if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'CORO') then substring($msg, 16, 3)
                    else ()
                }</ns2:currency>
              <ns2:amount>{
                let $msg := fn:data($tx/ns1:HIOP_O_0003_0006)
                let $type := fn:data($tx/ns1:HIOP_O_0003_0003)
                return   
                   if (fn:data($tx/ns1:HIOP_O_0003_0003) = 'PTFI') then
                   let $rawAmount := substring($msg, 29, 15)
                return xs:integer($rawAmount) div 100
              
                    else if ($type = 'PASI') then
                        let $rawAmount := substring($msg, 71, 15)
                      return xs:integer($rawAmount) div 100
                    
                  else if ($type = 'TFCM') then
                      let $rawAmount := substring($msg, 1, 15)
                   return xs:integer($rawAmount) div 100
              
                  else if ($type = 'PAGS') then
                    let $rawAmount := substring($msg, 29, 13)
                    return xs:integer($rawAmount) div 100
                    
                    else if ($type = 'INSS') then
                    let $rawAmount := substring($msg, 1, 15)
                      return xs:integer($rawAmount) div 100
                      
                     else if ($type = 'PTFZ') then
                let $currencyPos := string-length(substring-before($msg, 'MZN')) + 1
                let $amountStart := $currencyPos - 15
                let $rawAmount := substring($msg, $amountStart, 15)
                return xs:integer($rawAmount) div 100
                
                     else if ($type = 'CORO') then
                    let $rawAmount := substring($msg, 1, 15)
                    return xs:integer($rawAmount) div 100       
                  else ()
              }</ns2:amount>
              </ns2:debitAmount>
                <ns2:payeeName>{fn:data($tx/ns1:HIOP_O_0003_00031)}</ns2:payeeName>
                <ns2:payeeBankName></ns2:payeeBankName>
                <ns2:payeeAddress></ns2:payeeAddress>
                <ns2:payeeBankAddress></ns2:payeeBankAddress>
            </ns2:outwardremittances>
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response, $Request,$userId,$pageNo)