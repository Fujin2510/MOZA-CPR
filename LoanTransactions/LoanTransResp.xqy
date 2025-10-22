xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabanca.org/CMOV/LoanTrans";
(:: import schema at "LoanTransactionMSB.xsd" ::)
declare namespace ns2 = "http://www.mozabanca.org/obdx/LoanTrans";
(:: import schema at "LoanTransOBDX.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $branchCode as xs:string external;
declare variable $LoanResp as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func(
  $LoanResp as element() (:: schema-element(ns1:Response) ::),
  $branchCode as xs:string
) as element() (:: schema-element(ns2:Response) ::) {
 let $errCode := fn:data($LoanResp/*:errorCode) return
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
                 else if(fn:data($LoanResp/ns1:errorCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($LoanResp/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($LoanResp/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
      <ns2:totalRecords>{count($LoanResp/ns1:operationData/ns1:CMOV_O_0011)}</ns2:totalRecords>
      <ns2:startSequence/>

      <!--{
        if (count($LoanResp/ns1:operationData/ns1:CMOV_O_0011) = 0) then
          <ns2:statementItemList/>
        else-->
        {
          for $CMOV in $LoanResp/ns1:operationData/ns1:CMOV_O_0011
          return
            <ns2:statementItemList>
              <ns2:dictionaryArray/>
              <ns2:amount>
                <ns2:currency>{fn:data($CMOV/ns1:CMOV_O_0011_0008)}</ns2:currency>
               <ns2:amount>
{
  let $raw := fn:normalize-space($CMOV/ns1:CMOV_O_0011_0006)
  return
    if ($raw != '') then
      let $amount := xs:decimal($raw) div 100
      let $str := fn:string($amount)
      return
        if (contains($str, '.')) then
          let $afterDecimal := substring-after($str, '.')
          return
            if (string-length($afterDecimal) = 1) then
              concat($str, '0')
            else
              $str
        else
          concat($str, '.00')
    else
      '0.00'
}
</ns2:amount>

              </ns2:amount>

              <ns2:accountId>{fn:data($LoanResp/ns1:operationData/ns1:CMOV_O_0001)}</ns2:accountId>
              <ns2:creditAccountId/>
              <ns2:branchId>{$branchCode}</ns2:branchId>
              <ns2:subSequenceNumber/>
              <ns2:transactionType>
                {
                  if (data($CMOV/ns1:CMOV_O_0011_0007) = '+')
                  then 'C'
                  else 'D'
                }
              </ns2:transactionType>
              <ns2:externalReferenceId>{fn:data($CMOV/ns1:CMOV_O_0011_0018)}</ns2:externalReferenceId>
              <ns2:transactionDate>
                <ns2:dateString>{concat(fn:data($CMOV/ns1:CMOV_O_0011_0001), '000000')}</ns2:dateString>
                <ns2:monthDate/>
                <ns2:calendarDayOfWeek/>
                <ns2:monthDateTime/>
                <ns2:weekOfYear/>
                <ns2:lastDayOfMonth/>
                <ns2:sqltimestamp/>
                <ns2:time/>
                <ns2:timestamp/>
                <ns2:sqlDate/>
                <ns2:yearMonth/>
                <ns2:leapYear/>
                <ns2:dayOfYear/>
                <ns2:month/>
                <ns2:dayOfWeek/>
                <ns2:millis/>
                <ns2:yearMonthDate/>
                <ns2:year/>
                <ns2:dayOfMonth/>
                <ns2:infinite/>
                <ns2:null/>
              </ns2:transactionDate>
              <ns2:postingDate>
                <ns2:dateString>{concat(fn:data($CMOV/ns1:CMOV_O_0011_0001), '000000')}</ns2:dateString>
                <ns2:monthDate/>
                <ns2:calendarDayOfWeek/>
                <ns2:monthDateTime/>
                <ns2:weekOfYear/>
                <ns2:lastDayOfMonth/>
                <ns2:sqltimestamp/>
                <ns2:time/>
                <ns2:timestamp/>
                <ns2:sqlDate/>
                <ns2:yearMonth/>
                <ns2:leapYear/>
                <ns2:dayOfYear/>
                <ns2:month/>
                <ns2:dayOfWeek/>
                <ns2:millis/>
                <ns2:yearMonthDate/>
                <ns2:year/>
                <ns2:dayOfMonth/>
                <ns2:infinite/>
                <ns2:null/>
              </ns2:postingDate>
              <ns2:description>{fn:data($CMOV/ns1:CMOV_O_0011_0005)}</ns2:description>
              <ns2:valueDate>
                <ns2:dateString>{concat(fn:data($CMOV/ns1:CMOV_O_0011_0014), '000000')}</ns2:dateString>
                <ns2:monthDate/>
                <ns2:calendarDayOfWeek/>
                <ns2:monthDateTime/>
                <ns2:weekOfYear/>
                <ns2:lastDayOfMonth/>
                <ns2:sqltimestamp/>
                <ns2:time/>
                <ns2:timestamp/>
                <ns2:sqlDate/>
                <ns2:yearMonth/>
                <ns2:leapYear/>
                <ns2:dayOfYear/>
                <ns2:month/>
                <ns2:dayOfWeek/>
                <ns2:millis/>
                <ns2:yearMonthDate/>
                <ns2:year/>
                <ns2:dayOfMonth/>
                <ns2:infinite/>
                <ns2:null/>
              </ns2:valueDate>
              <ns2:transactionReferenceNumber>{fn:data($CMOV/ns1:CMOV_O_0011_0018)}</ns2:transactionReferenceNumber>
            </ns2:statementItemList>
      }
    </ns2:data>
  </ns2:Response>
};

local:func($LoanResp, $branchCode)