xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabanca.org/cmov";
(:: import schema at "../MSB_Schema/CMOV.xsd" ::)
declare namespace ns2 = "http://www.mozabank.org/CCC_ACCOUNT_TXN_STMT";
(:: import schema at "../OBDX_Schema/CCC_ACCOUNT_TXN_STMT.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) 
  as element() (:: schema-element(ns2:Response) ::) {
  
let $errCode := fn:data($Response/ns1:errorCode)
  let $txns := $Response/ns1:operationData/ns1:CMOV_O_0011
  let $hasTxn := fn:exists($txns)

  return
  <ns2:Response>  
    <ns2:data>
      <ns2:dictionaryArray/>
      <ns2:referenceNo/>
    
      <ns2:result>
        <ns2:dictionaryArray/>
        <ns2:externalReferenceId>
          {fn:data($Response/ns1:operationData/ns1:CMOV_O_0011[1]/ns1:CMOV_O_0011_0018)}
        </ns2:externalReferenceId>
        
        <!-- Determine status -->
        <ns2:status>
          {
            if ($errCode = '0') then 'SUCCESS' else 'FAILURE'
          }
        </ns2:status>

        <!-- Error Handling -->
        {
          if ($errCode != '0') then (
            <ns2:errorList>
              <ns2:code>{$errCode}</ns2:code>
              <ns2:message>
                {
                  let $msg := fn:data($Response/ns1:errorMessage/*:messages)
                  return if ($msg) then $msg else 'Invalid backend response'
                }
              </ns2:message>
            </ns2:errorList>
          ) else ()
        }

        <ns2:warningList/>
      </ns2:result>
    
      <ns2:hasMore/>
      <ns2:totalRecords/>
      <ns2:startSequence/>
    
      {
        (: If transactions exist, return them :)
        if ($errCode = '0' and $hasTxn) then
          for $txn at $i in $txns
          return
            <ns2:statementItemList>
              <ns2:dictionaryArray/>
              <ns2:externalReferenceId>{fn:data($txn/ns1:CMOV_O_0011_0018)}</ns2:externalReferenceId>
              <ns2:subSequenceNumber>
                {
                  if ($i lt 10) then concat("00", string($i))
                  else if ($i lt 100) then concat("0", string($i))
                  else string($i)
                }
              </ns2:subSequenceNumber>
              <ns2:date>
                {
                  let $date := fn:data($txn/ns1:CMOV_O_0011_0001)
                  return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                }
              </ns2:date>
              <ns2:valueDate>
                {
                  let $date := fn:data($txn/ns1:CMOV_O_0011_0014)
                  return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                }
              </ns2:valueDate>
              <ns2:documentNo>{fn:data($txn/ns1:CMOV_O_0011_0003)}</ns2:documentNo>
              <ns2:desc>{fn:data($txn/ns1:CMOV_O_0011_0005)}</ns2:desc>
              <ns2:amount>
                <ns2:currency>{fn:data($txn/ns1:CMOV_O_0011_0008)}</ns2:currency>
                <ns2:amount>
                  {
                    let $amount := xs:decimal(fn:data($txn/ns1:CMOV_O_0011_0006)) div 100
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
              </ns2:amount>
              <ns2:balance>
                <ns2:currency>{fn:data($txn/ns1:CMOV_O_0011_0008)}</ns2:currency>
                <ns2:amount>
                  {
                    let $amount := xs:decimal(fn:data($txn/ns1:CMOV_O_0011_0012)) div 100
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
              </ns2:balance>
            </ns2:statementItemList>

        (: Else, output one empty transaction block :)
        else
          <ns2:statementItemList>
            <ns2:dictionaryArray/>
            <ns2:externalReferenceId/>
            <ns2:subSequenceNumber/>
            <ns2:date/>
            <ns2:valueDate/>
            <ns2:documentNo/>
            <ns2:desc/>
            <ns2:amount>
              <ns2:currency/>
              <ns2:amount/>
            </ns2:amount>
            <ns2:balance>
              <ns2:currency/>
              <ns2:amount/>
            </ns2:balance>
          </ns2:statementItemList>
      }
    </ns2:data>
  </ns2:Response>
};

local:func($Response)