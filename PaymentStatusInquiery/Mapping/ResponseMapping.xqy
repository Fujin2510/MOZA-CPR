xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/cmov";
(:: import schema at "../XSD/CMOV.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/cz_outward_remittance_list";
(:: import schema at "../XSD/CZ_OUTWARD_REMITTANCE_LIST.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $userId as xs:string external;
declare variable $pageNo as xs:string external;
declare variable $paymentType as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$userId,$pageNo,$paymentType) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($Response/*:errorCode) 
(: --- Paging controls --- :)
let $pageSize := 10
let $page :=
  if (normalize-space($pageNo) castable as xs:integer and xs:integer($pageNo) > 0)
  then xs:integer($pageNo)
  else 1

let $allRecords :=
  for $tx in $Response/ns1:operationData/ns1:CMOV_O_0011
  order by 
    $tx/ns1:CMOV_O_0011_0001 descending,
    $tx/ns1:CMOV_O_0011_0018 descending
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
              count($Response/ns1:operationData/ns1:CMOV_O_0011)
            }</ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
             {
              if ($errCode = '0') then
  for $tx in $pagedRecords
return
            <ns2:outwardremittances>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId>{$userId}</ns2:partyId>
                <ns2:paymentDate>{
                  concat(
                    substring($tx/ns1:CMOV_O_0011_0001, 1, 4), "-",       (: Year :)
                    substring($tx/ns1:CMOV_O_0011_0001, 5, 2), "-",       (: Month :)
                    substring($tx/ns1:CMOV_O_0011_0001, 7, 2), "T",       (: Day + T :)
                    "00:00:00"                                             (: Time :)
                  )
                }</ns2:paymentDate>
                <ns2:purposeId></ns2:purposeId>
                <ns2:remarks></ns2:remarks>
                <ns2:bankCharges></ns2:bankCharges>
                <ns2:exchangeRate></ns2:exchangeRate>
                <ns2:transactionAmount>
                    <ns2:currency>{fn:data($tx/ns1:CMOV_O_0011_0011)}</ns2:currency>
                <ns2:amount>{
  xs:decimal(fn:data($tx/ns1:CMOV_O_0011_0009)) div 100
}</ns2:amount>
                </ns2:transactionAmount>
                <ns2:debitAccount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:accountId>{fn:data($Response/ns1:operationData/ns1:CMOV_O_0001)}</ns2:accountId>
                    <ns2:currency></ns2:currency>
                    <ns2:bankCode></ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:iban></ns2:iban>
                </ns2:debitAccount>
                <ns2:creditAccount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:accountId></ns2:accountId>
                    <ns2:currency></ns2:currency>
                    <ns2:bankCode></ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:iban></ns2:iban>
                </ns2:creditAccount>
                <ns2:txnReferenceId> {
    concat(fn:data($tx/ns1:CMOV_O_0011_0003), '#', fn:data($tx/ns1:CMOV_O_0011_0018))
  }</ns2:txnReferenceId>
                <ns2:paymentStatus>S</ns2:paymentStatus>
                <ns2:paymentType>{$paymentType}</ns2:paymentType>
                <ns2:description>{fn:data($tx/ns1:CMOV_O_0011_0005)}</ns2:description>
                <ns2:receiptBase64></ns2:receiptBase64>
                <ns2:fundReceivedDate>{
                  concat(
                    substring($tx/ns1:CMOV_O_0011_0014, 1, 4), "-",       (: Year :)
                    substring($tx/ns1:CMOV_O_0011_0014, 5, 2), "-",       (: Month :)
                    substring($tx/ns1:CMOV_O_0011_0014, 7, 2), "T",       (: Day + T :)
                    "00:00:00"                                             (: Time :)
                  )
                }</ns2:fundReceivedDate>
                <ns2:fundCreditedDate>{
                  concat(
                    substring($tx/ns1:CMOV_O_0011_0001, 1, 4), "-",       (: Year :)
                    substring($tx/ns1:CMOV_O_0011_0001, 5, 2), "-",       (: Month :)
                    substring($tx/ns1:CMOV_O_0011_0001, 7, 2), "T",       (: Day + T :)
                    "00:00:00"                                             (: Time :)
                  )
                }</ns2:fundCreditedDate>
                <ns2:orderingPartyId></ns2:orderingPartyId>
                <ns2:debitAmount>
                    <ns2:currency>{fn:data($tx/ns1:CMOV_O_0011_0011)}</ns2:currency>
                    <ns2:amount>{
  xs:decimal(fn:data($tx/ns1:CMOV_O_0011_0009)) div 100
}</ns2:amount>
                </ns2:debitAmount>
                <ns2:payeeName></ns2:payeeName>
                <ns2:payeeBankName></ns2:payeeBankName>
                <ns2:payeeAddress></ns2:payeeAddress>
                <ns2:payeeBankAddress></ns2:payeeBankAddress>
            </ns2:outwardremittances>
            else()
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$userId,$pageNo,$paymentType)