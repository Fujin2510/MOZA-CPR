xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CLED";
(:: import schema at "../Schema/CLED.xsd" ::)
declare namespace ns2="http://www.mozabank.org/LEASE_ACCOUNT_READ";
(:: import schema at "../Schema/LEASE_ACCOUNT_READ.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($Response/*:errorCode) return
    
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>

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
     if($errCode = '0') then 
            <ns2:account>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:productName>{fn:data($Response/ns1:operationData/ns1:CLED_O_0002)}</ns2:productName>
                <ns2:branchName>{fn:data($Response/ns1:operationData/ns1:CLED_O_0004)}</ns2:branchName>
                <ns2:accountId>{fn:data($Response/ns1:operationData/ns1:CLED_O_0001)}</ns2:accountId>
                <ns2:leasingAmount>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CLED_O_0018)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:CLED_O_0012)) div 100
                  return
                    if ($amount = xs:integer($amount)) then
                      concat(xs:string($amount), '.00')
                    else
                      let $str := xs:string($amount),
                          $dec := substring-after($str, '.'),
                          $pad := substring('00', string-length($dec) + 1)
                      return concat(substring-before($str, '.'), '.', $dec, $pad)
                }
                </ns2:amount>
                </ns2:leasingAmount>
                <ns2:startingAmount>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CLED_O_0018)}</ns2:currency>
                    <ns2:amount>
                    {
                  let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:CLED_O_0013)) div 100
                  return
                    if ($amount = xs:integer($amount)) then
                      concat(xs:string($amount), '.00')
                    else
                      let $str := xs:string($amount),
                          $dec := substring-after($str, '.'),
                          $pad := substring('00', string-length($dec) + 1)
                      return concat(substring-before($str, '.'), '.', $dec, $pad)
                }				
                    </ns2:amount>
                </ns2:startingAmount>
                <ns2:percentageOfStartingAmt>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CLED_O_0018)}</ns2:currency>
                  <ns2:amount>
                  {
                    let $raw := fn:data($Response/ns1:operationData/ns1:CLED_O_0014)
                    let $length := string-length($raw)
                    let $intPart := 
                      if ($length > 3) then substring($raw, 1, $length - 3)
                      else '0'
                    let $decPart := 
                      if ($length >= 3) then substring($raw, $length - 2)
                      else concat(substring('000', $length + 1), $raw)
                    return concat($intPart, '.', $decPart)
                  } 
                  </ns2:amount>
                </ns2:percentageOfStartingAmt>
                <ns2:residualValue>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CLED_O_0018)}</ns2:currency>
               <ns2:amount>  {
                  let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:CLED_O_0015)) div 100
                  return
                    if ($amount = xs:integer($amount)) then
                      concat(xs:string($amount), '.00')
                    else
                      let $str := xs:string($amount),
                          $dec := substring-after($str, '.'),
                          $pad := substring('00', string-length($dec) + 1)
                      return concat(substring-before($str, '.'), '.', $dec, $pad)
                }</ns2:amount>
                </ns2:residualValue>
                <ns2:amtInDebt>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CLED_O_0018)}</ns2:currency>
                    <ns2:amount>                {
                  let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:CLED_O_0017)) div 100
                  return
                    if ($amount = xs:integer($amount)) then
                      concat(xs:string($amount), '.00')
                    else
                      let $str := xs:string($amount),
                          $dec := substring-after($str, '.'),
                          $pad := substring('00', string-length($dec) + 1)
                      return concat(substring-before($str, '.'), '.', $dec, $pad)
                }</ns2:amount>
                </ns2:amtInDebt>

<ns2:percentageOfResidualValue>
{
  let $val := xs:integer(fn:data($Response/ns1:operationData/ns1:CLED_O_0016))
  let $valStr := string($val)
  let $len := string-length($valStr)
  let $intPart := if ($len > 3) then substring($valStr, 1, $len - 3) else '0'
  let $decPart := substring($valStr, $len - 2, 3)
  return concat($intPart, '.', $decPart)
}
</ns2:percentageOfResidualValue>


<ns2:interestRate>{
   xs:decimal($Response/ns1:operationData/ns1:CLED_O_0011) div 100000
}</ns2:interestRate>


                <ns2:startingDate>
                   {
                      let $date := fn:data($Response/ns1:operationData/ns1:CLED_O_0005)
                      return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                   }
                </ns2:startingDate>
                <ns2:dueDate>
                        {
                          let $date := fn:data($Response/ns1:operationData/ns1:CLED_O_0006)
                          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                        }
                </ns2:dueDate>
                <ns2:dateOfLastInstallment>
                        {
                          let $date := fn:data($Response/ns1:operationData/ns1:CLED_O_0007)
                          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                        }
                </ns2:dateOfLastInstallment>
                <ns2:dateOfNextInstallment>
                        {
          let $date := fn:data($Response/ns1:operationData/ns1:CLED_O_0008)
          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
        }
                </ns2:dateOfNextInstallment>
                <ns2:amountOfNextInstallment>
                    <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CLED_O_0018)}</ns2:currency>
                    <ns2:amount>                {
                  let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:CLED_O_0009)) div 100
                  return
                    if ($amount = xs:integer($amount)) then
                      concat(xs:string($amount), '.00')
                    else
                      let $str := xs:string($amount),
                          $dec := substring-after($str, '.'),
                          $pad := substring('00', string-length($dec) + 1)
                      return concat(substring-before($str, '.'), '.', $dec, $pad)
                }</ns2:amount>
                </ns2:amountOfNextInstallment>
                <ns2:primaryAccountHolder>{$userIdVar}</ns2:primaryAccountHolder>
            </ns2:account>
else()
}
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$userIdVar)