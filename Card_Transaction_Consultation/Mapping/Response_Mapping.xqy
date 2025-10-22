xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabanca.org/ctcd";
 
declare namespace ns2 = "http://www.mozabank.org/CTCD_TRANSACTION_LIST";
 
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CTCD_Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($CTCD_Response as element() (:: schema-element(ns1:Response) ::))
 
as element() (:: schema-element(ns2:Response) ::) {

  let $errCode := fn:data($CTCD_Response/*:errorCode)

  return
<ns2:Response>
<ns2:data>
<ns2:dictionaryArray></ns2:dictionaryArray>
<ns2:result>
<ns2:dictionaryArray></ns2:dictionaryArray>
<!-- status -->
<ns2:status>
 
        { if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }
</ns2:status>
<!-- error handling -->
 
      {
 
        if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
 
        else if ($errCode = 'C') then
 
          (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CTCD_Response/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CTCD_Response/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($CTCD_Response/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
</ns2:errorList>
 
          )
 
        else if ($errCode = '906' or $errCode = 'A') then
 
          (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', "Invalid Backend response") }</ns2:message>
</ns2:errorList>
 
          )
 
        else
 
          (
<ns2:errorList>
<ns2:code>ERR001</ns2:code>
<ns2:message>Invalid backend response</ns2:message>
</ns2:errorList>
 
          )
 
      }
<ns2:warningList></ns2:warningList>
</ns2:result>

    {
 
      if ($errCode = '0') then
 
        let $records := $CTCD_Response/ns1:operationData/ns1:CTCD_O_0003
 
        return
 
          if (empty($records)) then
 
            (: Return default block when no records exist :)
<ns2:transactionList>
<ns2:transactionRegistrationDate></ns2:transactionRegistrationDate>
<ns2:orderNumber></ns2:orderNumber>
<ns2:requestDate></ns2:requestDate>
<ns2:requestTime></ns2:requestTime>
<ns2:transactionValue></ns2:transactionValue>
<ns2:transactionCurrency></ns2:transactionCurrency>
<ns2:transactionType></ns2:transactionType>
<ns2:terminalType></ns2:terminalType>
<ns2:terminalSupportBench></ns2:terminalSupportBench>
<ns2:terminalLocation></ns2:terminalLocation>
</ns2:transactionList>
 
          else
 
            for $rec in $records
 
            order by xs:dateTime(
 
                        concat(
 
                          substring($rec/ns1:CTCD_O_0003_0001,1,4), '-',
 
                          substring($rec/ns1:CTCD_O_0003_0001,5,2), '-',
 
                          substring($rec/ns1:CTCD_O_0003_0001,7,2), 'T',
 
                          substring($rec/ns1:CTCD_O_0003_0004,1,2), ':',
 
                          substring($rec/ns1:CTCD_O_0003_0004,3,2), ':',
 
                          substring($rec/ns1:CTCD_O_0003_0004,5,2)
 
                        )
 
                     ) descending
 
            return
<ns2:transactionList>
<ns2:transactionRegistrationDate>{
 
                  let $date := fn:data($rec/ns1:CTCD_O_0003_0001)
 
                  return concat(substring($date,1,4), '-', substring($date,5,2), '-', substring($date,7,2), 'T00:00:00')
 
                }</ns2:transactionRegistrationDate>
<ns2:orderNumber>{fn:data($rec/ns1:CTCD_O_0003_0002)}</ns2:orderNumber>
<ns2:requestDate>{
 
                  let $date := fn:data($rec/ns1:CTCD_O_0003_0003)
 
                  return concat(substring($date,1,4), '-', substring($date,5,2), '-', substring($date,7,2), 'T00:00:00')
 
                }</ns2:requestDate>
<ns2:requestTime>{fn:data($rec/ns1:CTCD_O_0003_0004)}</ns2:requestTime>
<ns2:transactionValue>{
 
                  let $amount := xs:decimal(fn:data($rec/ns1:CTCD_O_0003_0005)) div 100
 
                  return if ($amount = xs:integer($amount)) then
 
                            concat(xs:string($amount), '.00')
 
                         else
 
                            let $str := xs:string($amount),
 
                                $dec := substring-after($str, '.'),
 
                                $pad := substring('00', string-length($dec)+1)
 
                            return concat(substring-before($str, '.'), '.', $dec, $pad)
 
                }</ns2:transactionValue>
<ns2:transactionCurrency>{fn:data($rec/ns1:CTCD_O_0003_0006)}</ns2:transactionCurrency>
<ns2:transactionType>{' '}</ns2:transactionType>
<ns2:terminalType>{' '}</ns2:terminalType>
<ns2:terminalSupportBench>{fn:data($rec/ns1:CTCD_O_0003_0009)}</ns2:terminalSupportBench>
<ns2:terminalLocation>{fn:data($rec/ns1:CTCD_O_0003_0010)}</ns2:terminalLocation>
</ns2:transactionList>
 
      else ()
 
    }
</ns2:data>
</ns2:Response>

};

local:func($CTCD_Response)