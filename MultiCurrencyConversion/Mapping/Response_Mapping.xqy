xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/SELF_FX_CCY_TRANSFER";
(:: import schema at "../Schema/SELF_FX_CCY_TRANSFER.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/tfcd";
(:: import schema at "../Schema/TFCD.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $RefNo as xs:string external;
declare variable $confirmationStatus as xs:string external;
declare variable $currency as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:SELF_FX_CCY_TRANSFER_Response) ::) {
    <ns2:SELF_FX_CCY_TRANSFER_Response>
    <ns2:data>
            <ns2:result>
          <ns2:status>
            {
              if (fn:data($Response/ns1:errorCode) = '0')
              then 'SUCCESS'
              else 'FAILURE'
            }
          </ns2:status>
          
          {
            if (fn:data($Response/ns1:errorCode) != '0') then (
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
              </ns2:errorList>
            ) else ()
          }

          </ns2:result>
            <ns2:confirmationStatus>{$confirmationStatus}</ns2:confirmationStatus>
            <ns2:referenceNo>{$RefNo}</ns2:referenceNo>
            <ns2:finalValue>
            {
              let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0001)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }
            </ns2:finalValue>

            <ns2:exchangeRate>
              {
                let $raw := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0002)) div 1000000000
                return
                  concat(xs:string($raw), substring('000000000', string-length(substring-after(xs:string($raw), '.')) + 1))
              }
              </ns2:exchangeRate>


          
        <ns2:totalExpenses>
        {
          let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0005)) div 100
          return
            if ($amount = xs:integer($amount)) then
              concat(xs:string($amount), '.00')
            else
              let $str := xs:string($amount),
                  $dec := substring-after($str, '.'),
                  $pad := substring('00', string-length($dec) + 1)
              return concat(substring-before($str, '.'), '.', $dec, $pad)
        }
        </ns2:totalExpenses>

            
            <ns2:opterationLiquidValue>
            {
              let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0006)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }
            </ns2:opterationLiquidValue>

          
        <ns1:expenseValue>
        {
          let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0006)) div 100
          return
            if ($amount = xs:integer($amount)) then
              concat(xs:string($amount), '.00')
            else
              let $str := xs:string($amount),
                  $dec := substring-after($str, '.'),
                  $pad := substring('00', string-length($dec) + 1)
              return concat(substring-before($str, '.'), '.', $dec, $pad)
        }
        </ns1:expenseValue>

            
            <ns2:instanceNumber>{fn:data($Response/ns1:operationData/ns1:TFCD_O_0007)}</ns2:instanceNumber>
            <ns2:debitAmount>
            {
              let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0003)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }
            </ns2:debitAmount>

            
            <ns2:debitCurrency>{$currency}</ns2:debitCurrency>
           
            <ns2:creditAmount>
            {
              let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:TFCD_O_0006)) div 100
              return
                if ($amount = xs:integer($amount)) then
                  concat(xs:string($amount), '.00')
                else
                  let $str := xs:string($amount),
                      $dec := substring-after($str, '.'),
                      $pad := substring('00', string-length($dec) + 1)
                  return concat(substring-before($str, '.'), '.', $dec, $pad)
            }
            </ns2:creditAmount>

        <ns2:creditCurrency>MZN</ns2:creditCurrency>
        </ns2:data>
        <!--
        <ns2:messages>
            <ns2:keyId></ns2:keyId>
            <ns2:status>
            {
                if (fn:data($Response/ns1:errorCode) = '0')
                then 'SUCCESS'
                else 'FAILURE'
            }
            </ns2:status>
            <ns2:codes></ns2:codes>
            <ns2:requestId></ns2:requestId>
            <ns2:httpStatusCode>
            {
                if (fn:data($Response/ns1:errorCode)='0')
                then 'OK'
                else '500'
            }
            </ns2:httpStatusCode>
            <ns2:overrideAuthLevelsReqd></ns2:overrideAuthLevelsReqd>
        </ns2:messages>
        -->

    </ns2:SELF_FX_CCY_TRANSFER_Response>
};

local:func($Response)