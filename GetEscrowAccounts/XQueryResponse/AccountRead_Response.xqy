xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CCC_ACCOUNT_READ";
(:: import schema at "../OBDX_Schema/CCC_ACCOUNT_READ.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/cdcc";
(:: import schema at "../MSB_Schema/CDCC.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CDCC_Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($CDCC_Response as element() (:: schema-element(ns1:Response) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($CDCC_Response/*:errorCode) return

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

                 else if(fn:data($CDCC_Response/ns1:errorCode) = 'C') then 

                 (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CDCC_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CDCC_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
        <ns2:account>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:partyId>{fn:data($CDCC_Response/ns1:user)}</ns2:partyId>
            <!-- <ns2:branchCode>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0003)}</ns2:branchCode> -->
            <ns2:branchName>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0004)}</ns2:branchName>
            <ns2:accountId>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0001)}</ns2:accountId>
            <ns2:loanAmount>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0005)) div 100
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

            </ns2:loanAmount>
            <ns2:accountingBalance>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0007)) div 100
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

            </ns2:accountingBalance>
            <ns2:avgAmtBalance>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0014)) div 100
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

            </ns2:avgAmtBalance>
            <ns2:availableBalance>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                  <ns2:amount>
                  {
                    let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0009)) div 100
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

            </ns2:availableBalance>
            <ns2:overdraftLimit>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0013)) div 100
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

            </ns2:overdraftLimit>
            <ns2:debitOnHold>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0011)) div 100
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

            </ns2:debitOnHold>
            <ns2:creditOnHold>
                <ns2:currency>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0006)}</ns2:currency>
                <ns2:amount>
                {
                  let $amount := xs:decimal(fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0012)) div 100
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

            </ns2:creditOnHold>
            <ns2:dueDate> 
            {
              let $date := fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0016)
              return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
            }
            </ns2:dueDate>
            <ns2:nextInterestDebitDate> 
            {
              let $date := fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0017)
              return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
            }
            </ns2:nextInterestDebitDate>
            <ns2:statementType>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0018)}</ns2:statementType>
            <ns2:statementFreq>{fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0019)}</ns2:statementFreq>
      	<ns2:lastStatementDate>
		{
		  let $date := fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0020)
		  return 
			if ($date != '' and $date != '00000000') then 
			  concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
			else 
			  ()
		}
</ns2:lastStatementDate>
              <ns2:lastStatementNumber>
              {
                fn:data($CDCC_Response/ns1:operationData/ns1:CDCC_O_0021)
                
              }
              </ns2:lastStatementNumber>
<ns2:interestRate>
{
  fn:concat(
    fn:string(xs:decimal($CDCC_Response/ns1:operationData/ns1:CDCC_O_0022) div 1000000),
    "%"
  )
}
</ns2:interestRate>


            <ns2:primaryAccountHolder>{$userIdVar}</ns2:primaryAccountHolder>
        </ns2:account>
        </ns2:data>
    </ns2:Response>
};

local:func($CDCC_Response,$userIdVar)