xquery version "1.0" encoding "utf-8";
  
  (:: OracleAnnotationVersion "1.0" ::)
  
  declare namespace ns1="http://www.mozabank.org/CCARCreditCard";
  (:: import schema at "XSD/CCAR.xsd" ::)
  declare namespace ns2="http://www.mozabank.org/CCCACreditCard";
  (:: import schema at "XSD/CCCA.xsd" ::)
  declare namespace ns3="http://www.mozabank.org/CREDIT_CARD_READ";
  (:: import schema at "XSD/CREDIT_CARD_READ.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";
  
  declare variable $Response_CCAR as element() (:: schema-element(ns1:Response) ::) external;
  declare variable $Response_CccaCdca as element() (:: schema-element(ns2:CCCAResponse) ::) external;
  declare variable $idVar as xs:string external;
  declare function local:func($Response_CCAR as element() (:: schema-element(ns1:Response) ::), 
                              $Response_CccaCdca as element() (:: schema-element(ns2:CCCAResponse) ::),$idVar) 
                              as element() (:: schema-element(ns3:Response) ::) {
  let $errCode := xs:string(fn:data($Response_CCAR/*:errorCode)) return
      <ns3:Response>
          <ns3:data>
              <ns3:dictionaryArray></ns3:dictionaryArray>
              <ns3:referenceNo></ns3:referenceNo>
              <ns3:result>
                  <ns3:dictionaryArray></ns3:dictionaryArray>
                  <ns3:externalReferenceId></ns3:externalReferenceId>
        <ns3:status>{ if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }</ns3:status>
        {
          if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
          else if ($errCode = 'C') then
          (
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response_CCAR/*:errorMessage/*:messages[1])), '-'), 'ErrorCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response_CCAR/*:errorMessage/*:messages[1])), '-'), 'ErrorMessageEN', "Invalid backend response") }</ns3:message>
            </ns3:errorList>
          )
          else if ($errCode = '906' or $errCode = 'A') then
          (
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', "Invalid backend response") }</ns3:message>
            </ns3:errorList>
          )
          else
          (
            <ns3:errorList>
              <ns3:code>ERR001</ns3:code>
              <ns3:message>Invalid backend response</ns3:message>
            </ns3:errorList>
          )
        }
                  <ns3:warningList></ns3:warningList>
              </ns3:result>
              <ns3:hasMore></ns3:hasMore>
              <ns3:totalRecords></ns3:totalRecords>
              <ns3:startSequence></ns3:startSequence>
              {
               if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then
               let  $ccarResp := $Response_CCAR/ns1:operationData/ns1:CCAR_O_0003[ns1:CCAR_O_0003_0001 =  $idVar and ns1:CCAR_O_0003_0013 = 'CARC' ]
               let $cccaResp := $Response_CccaCdca/ns2:operationData/ns2:CCCA_O_0003[ns2:CCCA_O_0003_0001 = $ccarResp/ns1:CCAR_O_0003_0017]
              return
              <ns3:creditCard>
           <ns3:dictionaryArray>
           <ns3:nameValuePairArray>
                      <ns3:name>AmountOnHold</ns3:name>
                 <!--       <ns3:value>100</ns3:value>  -->
<ns3:value>
  {
    let $raw := fn:data(
      $Response_CCAR/ns1:operationData/ns1:CCAR_O_0003
        [ns1:CCAR_O_0003_0001 = $idVar and ns1:CCAR_O_0003_0013 = 'CARC']
        /ns1:CCAR_O_0003_0016
    )
    return (
     
      fn-bea:format-number(xs:decimal($raw) div 100, '0.00')
    )
  }
</ns3:value>


                      <ns3:genericName>com.finonyx.digx.cz.domain.card.entity.credit.CZCredit.AmountOnHold</ns3:genericName>
                      <ns3:datatype>java.lang.String</ns3:datatype>
                  </ns3:nameValuePairArray>
                  <ns3:nameValuePairArray>
                      <ns3:name>ChangePaymentOption</ns3:name>
                 <!--       <ns3:value>100</ns3:value>  -->
<ns3:value>
  { concat(number(fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0021)), '%') }
</ns3:value>                      
<ns3:genericName>com.finonyx.digx.cz.domain.card.entity.credit.CZCredit.ChangePaymentOption</ns3:genericName>
                      <ns3:datatype>java.lang.String</ns3:datatype>
                  </ns3:nameValuePairArray>
              </ns3:dictionaryArray>  
                  <ns3:ownerName>{fn:data($ccarResp/ns1:CCAR_O_0003_0004)}</ns3:ownerName>
                  <ns3:issuer>MOZA BANCO</ns3:issuer>
                  <ns3:validity>
                  
                      <ns3:start>
                      {let $date := fn:data($ccarResp/ns1:CCAR_O_0003_0007) return 
                      concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                      </ns3:start>
                      <ns3:end>
                      {let $date := fn:data($ccarResp/ns1:CCAR_O_0003_0008) return 
                      concat(substring($date,1,4),'-',substring($date,5,2),'-','01T00:00:00')}
                      </ns3:end>
                  </ns3:validity>
                  <ns3:creditCard>{fn:data($ccarResp/ns1:CCAR_O_0003_0001)}</ns3:creditCard>
                  <ns3:displayValue>
                  {fn:data($ccarResp/ns1:CCAR_O_0003_0003)}
                  </ns3:displayValue>
<ns3:cardStatus>
{
  let $value1 := fn:data($ccarResp/ns1:CCAR_O_0003_0011)
  return 
    if ($value1 = 'Normal') then 'ACT' 
    else if ($value1 = 'Lista Negra') then 'BLK'
    else if ($value1 = 'Lista cinzenta') then 'BLK'
    else if ($value1 = 'Capturado a não devolver') then 'BLK'
    else 'IAT'
}
</ns3:cardStatus>
                  <ns3:cardProductDetails>
                      <ns3:dictionaryArray></ns3:dictionaryArray>
                      <ns3:id>{fn:data($ccarResp/ns1:CCAR_O_0003_0020)}</ns3:id>
                      <ns3:description>{fn:data($ccarResp/ns1:CCAR_O_0003_0018)}</ns3:description>
                      <ns3:expiryDate>
                      {let $date := fn:data($ccarResp/ns1:CCAR_O_0003_0008) return 
                      concat(substring($date,1,4),'-',substring($date,5,2),'-','01T00:00:00')}
                      </ns3:expiryDate>
   <ns3:cardBrand>VISA</ns3:cardBrand>
                 <ns3:cardCategory>{
  let $val := fn:lower-case(fn:normalize-space(fn:data($cccaResp/ns2:CCCA_O_0003_0002)))
  return
    if (contains($val, "gold")) then "GOLD"
    else if (contains($val, "classic")) then "CLASSIC"
    else if (contains($val, "platinum")) then "PLATINUM"
    else if (contains($val, "next")) then "NEXT"

    else ""
}</ns3:cardCategory>
                    <ns3:issuer>{fn:data($ccarResp/ns1:CCAR_O_0003_0021)}</ns3:issuer>
                    <ns3:CardTechType>ICCCARD</ns3:CardTechType> 
                  </ns3:cardProductDetails>
                  <ns3:cardRelationShipDetails></ns3:cardRelationShipDetails>
                  <ns3:cardNickname>{fn:data($ccarResp/ns1:CCAR_O_0003_0013)}</ns3:cardNickname>
                  <ns3:currentAuthorizationAmount>
                      <ns3:currency>MZN</ns3:currency>
                     <ns3:amount>
                          {
                                let $raw := xs:string(fn:data($ccarResp/ns1:CCAR_O_0003_0014))
                                let $len := string-length($raw)
                                let $intPart := substring($raw, 1, $len - 2)
                                let $fracPart := substring($raw, $len - 1)
                                return xs:decimal(concat($intPart, ".", $fracPart))
                              }
                          </ns3:amount>
                  </ns3:currentAuthorizationAmount>
                  <ns3:billingCycleDay>{fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0024)}</ns3:billingCycleDay>
                  <ns3:rewardPoints>0</ns3:rewardPoints>
                  <ns3:due>
                      <ns3:dictionaryArray></ns3:dictionaryArray>
                      <ns3:billedAmount>
                          <ns3:currency>MZN</ns3:currency>
          <ns3:amount>
{
  let $cdcaRaw := normalize-space(fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0008))
  let $ccarRaw := normalize-space(fn:data($ccarResp/ns1:CCAR_O_0003_0016))

  let $cdcaVal := if ($cdcaRaw != "") then xs:decimal($cdcaRaw) else 0
  let $ccarVal := if ($ccarRaw != "") then xs:decimal($ccarRaw) else 0

  (: sum them first :)
  let $total := $cdcaVal + $ccarVal

  (: convert to decimal with 2 fractional digits :)
  let $len := string-length(xs:string($total))
  let $intPart := substring(xs:string($total), 1, $len - 2)
  let $fracPart := substring(xs:string($total), $len - 1)
  let $decimalVal := xs:decimal(concat($intPart, ".", $fracPart))

  return fn-bea:format-number($decimalVal, "0.00")
}
</ns3:amount>



                      </ns3:billedAmount>
                      <ns3:unbilledAmount>
                          <ns3:currency>MZN</ns3:currency>
                            <ns3:amount>
                          {
                                let $raw := xs:string(fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0008))
                                let $len := string-length($raw)
                                let $intPart := substring($raw, 1, $len - 2)
                                let $fracPart := substring($raw, $len - 1)
                                return xs:decimal(concat($intPart, ".", $fracPart))
                              }
                          </ns3:amount>
                      </ns3:unbilledAmount>
                      <ns3:minimumAmount>
                          <ns3:currency>MZN</ns3:currency>
                          <ns3:amount>
                          {
                                let $raw := xs:string(fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0016))
                                let $len := string-length($raw)
                                let $intPart := substring($raw, 1, $len - 2)
                                let $fracPart := substring($raw, $len - 1)
                                return xs:decimal(concat($intPart, ".", $fracPart))
                              }
                          </ns3:amount>
                      </ns3:minimumAmount>
                      <ns3:billedDate>
                      {let $date := fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0017) return 
                      if(fn:data(xs:long($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0017)) > 0) then 
                      concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00') else()}
                      </ns3:billedDate>
                      <ns3:paymentDueDate>
                      {let $date := fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0017) return 
                        if(fn:data(xs:long($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0017)) > 0) then 
                      concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00') else()}
                      </ns3:paymentDueDate>
                  </ns3:due>
                  <ns3:payment></ns3:payment>
                  <ns3:limits> 
                          <ns3:dictionaryArray></ns3:dictionaryArray>
                          <ns3:total>
                              <ns3:currency>MZN</ns3:currency>
                              <ns3:amount>
                              {fn-bea:format-number(fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0005), '0.00')}
                              </ns3:amount>
                          </ns3:total>
                          <ns3:available>
                              <ns3:currency>MZN</ns3:currency>
                              <ns3:amount>
                              {
                                let $raw := xs:string(fn:data($cccaResp/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0013))
                                let $len := string-length($raw)
                                let $intPart := substring($raw, 1, $len - 2)
                                let $fracPart := substring($raw, $len - 1)
                                return xs:decimal(concat($intPart, ".", $fracPart))
                              }
                              </ns3:amount>
                          </ns3:available>
                          <ns3:type>CR</ns3:type> 
                  </ns3:limits>
                  <ns3:cardOwnershipType>PRIMARY</ns3:cardOwnershipType>
                  <ns3:primaryCardId>{fn:data($ccarResp/ns1:CCAR_O_0003_0001)}</ns3:primaryCardId>
                  <ns3:cardCurrency>MZN</ns3:cardCurrency>
                  <ns3:internationalUsage>True</ns3:internationalUsage>
                 <!--  <ns3:cardType>PRIMARY</ns3:cardType> -->
              </ns3:creditCard>
              else()
              }
          </ns3:data>
      </ns3:Response>
  };
  
  local:func($Response_CCAR, $Response_CccaCdca,$idVar)