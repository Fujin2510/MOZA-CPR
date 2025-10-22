xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns4="http://www.mozabanca.org/ccar/obdx";
(:: import schema at "../DEBIT_CARD_LIST.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/cdod";
(:: import schema at "../../PrepaidCardBalance/Schema/CDOD.xsd" ::) 
declare namespace ns1="http://www.mozabank.org/CCAR";
(:: import schema at "../../PrepaidCardBalance/Schema/CCAR.xsd" ::)
declare namespace ns3="http://www.mozabank.org/PREPAID_CARD_BAL";
(:: import schema at "PrepaidCardBalance.xsd" ::)

declare variable $CardResponse as element() (:: schema-element(ns1:Card) ::) external;
declare variable $CDOD_Response as element() (:: schema-element(ns2:Response) ::) external;
declare variable $PrepaidBalResponse as element() (:: schema-element(ns3:Response) ::) external;

declare function local:func($CardResponse as element() (:: schema-element(ns1:Card) ::), 
                              $CDOD_Response as element() (:: schema-element(ns2:Response) ::),       
                            $PrepaidBalResponse as element() (:: schema-element(ns3:Response) ::)) 
                            as element() (:: schema-element(ns4:dictionaryArray) ::) {
 
        <ns4:dictionaryArray>
                {
                  let $subCardValue := fn:data($CardResponse/*:CCAR_O_0003_0020)
                  let $isPrepaid := if($subCardValue = "EUR_PPPAR" or $subCardValue = "VSA_PPPCP") then 'true' else 'false'
                  return (
                    <ns4:nameValuePairArray>
                      <ns4:name>PrepaidCardBalanceAmount</ns4:name>
                      <ns4:genericName>com.finonyx.digx.cz.domain.dda.entity.debitcard.CZDebitCard.PrepaidCardBalanceAmount</ns4:genericName>
                      <ns4:value>
                        {
                          if ($isPrepaid = 'true') then
                            let $amount := xs:decimal(fn:data($PrepaidBalResponse/ns3:data/ns3:BALANCE)) 
                            return
                              if ($amount = xs:integer($amount)) then
                                concat(xs:string($amount), '.00')
                              else
                                let $str := xs:string($amount),
                                    $dec := substring-after($str, '.'),
                                    $pad := substring('00', string-length($dec) + 1)
                                return concat(substring-before($str, '.'), '.', $dec, $pad)
                          else '00.00'
                        }
                      </ns4:value>
                      <ns4:datatype>java.lang.String</ns4:datatype>
                    </ns4:nameValuePairArray>,
                    <ns4:nameValuePairArray>
                      <ns4:name>PrepaidCardBalanceCurrency</ns4:name>
                      <ns4:genericName>com.finonyx.digx.cz.domain.dda.entity.debitcard.CZDebitCard.PrepaidCardBalanceCurrency</ns4:genericName>
                      <ns4:value>{ if ($isPrepaid = 'true') then 'MZN' else 'NA' }</ns4:value>
                      <ns4:datatype>java.lang.String</ns4:datatype>
                    </ns4:nameValuePairArray>,
                    <ns4:nameValuePairArray>
                      <ns4:name>SubCardType</ns4:name>
                      <ns4:genericName>com.finonyx.digx.cz.domain.dda.entity.debitcard.CZDebitCard.SubCardType</ns4:genericName>
                      <ns4:value>{ if ($isPrepaid = 'true') then 'P' else 'D' }</ns4:value>
                      <ns4:datatype>java.lang.String</ns4:datatype>
                    </ns4:nameValuePairArray>
                  )
                }
            </ns4:dictionaryArray>
         
};

local:func($CardResponse,$CDOD_Response,$PrepaidBalResponse)