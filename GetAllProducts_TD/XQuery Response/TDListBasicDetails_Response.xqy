xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPDAccountListResponse.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns3="http://www.mozabank.org/TD_LIST_BASIC_DETAILS";
(:: import schema at "../Schema/TD_LIST_BASIC_DETAILS.xsd" ::)
declare namespace ns4="http://www.mozabank.org/getTDProductDetails";
(:: import schema at "../../TermDeposit/Resources/Schema/GetTDProductDetails.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPD_Response as element() (:: schema-element(ns1:CAPDAccountObjectResponse) ::) external;
declare variable $CCAP_Response as element() (:: schema-element(ns2:Response) ::) external;
declare variable $userIdVar as xs:string external;
declare variable $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::) external;
declare function local:func($CAPD_Response as element() (:: schema-element(ns1:CAPDAccountObjectResponse) ::), 
                            $CCAP_Response as element() (:: schema-element(ns2:Response) ::),$userIdVar as xs:string,
                             $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::)) 
                            as element() (:: schema-element(ns3:TDBasicDetailsResponse) ::) {
  let $errCode := fn:data($CCAP_Response/*:errorCode)

  return
    <ns3:TDBasicDetailsResponse>
         <ns3:data>
        <ns3:dictionaryArray></ns3:dictionaryArray>
        <ns3:referenceNo></ns3:referenceNo>
        <ns3:result>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:externalReferenceId></ns3:externalReferenceId>
      <ns3:status>
        { if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE' }
      </ns3:status>
      {
        if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
        else if($errCode = 'C') then 
        (
          <ns2:errorList>
            <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns2:code>
            <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-')) }</ns2:message>
          </ns2:errorList>
        )
        else if($errCode = '906' or $errCode = 'A') then 
        (
          <ns2:errorList>
            <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns2:code>
            <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-')) }</ns2:message>
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
            <ns3:warningList></ns3:warningList>
        </ns3:result>
        <ns3:hasMore></ns3:hasMore>
        <ns3:totalRecords></ns3:totalRecords>
        <ns3:startSequence></ns3:startSequence>
        {
        for $capd in $CAPD_Response/ns1:operationData 
      let $ccap := $CCAP_Response/ns2:operationData/ns2:CCAP_O_0003[ns2:CCAP_O_0003_0001 = xs:string($capd/*:CAPD_O_0001)]  
      let $sdate05 := fn:data($capd/*:CAPD_O_0005)
      let $date06 := fn:data($capd/*:CAPD_O_0006)
      let $initialDate := xs:date(concat(substring($sdate05, 1, 4), '-', substring($sdate05, 5, 2), '-', substring($sdate05, 7, 2)))
      let $dueDate := xs:date(concat(substring($date06, 1, 4), '-', substring($date06, 5, 2), '-', substring($date06, 7, 2))  )
      let $duration := $dueDate - $initialDate
       let $daysDuration :=  days-from-duration($dueDate - $initialDate)
      return
        if($errCode = '0' or $errCode = 'P' or $errCode = 'B') then
          <ns3:accounts>
            <!-- <ns3:dictionaryArray></ns3:dictionaryArray> -->
            <ns3:partyId>{$userIdVar}</ns3:partyId>
            <ns3:accountId>{fn:data($capd/*:CAPD_O_0001)}</ns3:accountId>  
            <ns3:branchId>{fn:data($capd/*:CAPD_O_0003)}  </ns3:branchId>
            <ns3:currency>{fn:data($capd/*:CAPD_O_0009)}</ns3:currency>
            <ns3:status>ACTIVE</ns3:status>
           <ns3:availableBalance>
               <ns3:currency>{fn:data($capd/*:CAPD_O_0009)}</ns3:currency>
              <ns3:amount>
{
                let $raw := fn:data($capd/*:CAPD_O_0008)
                let $rawStr := string($raw)
                let $length := string-length($rawStr)
                return
                  if ($length gt 2) then
                  concat(xs:int(substring($rawStr, 1, $length - 2)), '.', substring($rawStr, $length - 1))
                  else ()
                  
              }
</ns3:amount>
            </ns3:availableBalance>
             <ns3:tenure>
                  {

                let $totalMonths := months-from-duration($duration)
                let $years := floor(xs:decimal($totalMonths) div 12)
                let $months := $totalMonths mod 12
                let $days := days-from-duration($duration)
                return (
                  <ns3:days>{ $days }</ns3:days>,
                  <ns3:months>{ $months }</ns3:months>,
                  <ns3:years>{ $years }</ns3:years>
                )
              }
             </ns3:tenure>
             
 <ns3:interestRate>
  {
    xs:decimal(
      concat(
        substring(fn:data($ccap/ns2:CCAP_O_0003_0007), 1, 3), ".", 
        substring(fn:data($ccap/ns2:CCAP_O_0003_0007), 4)
      )
    )
  }
</ns3:interestRate>            <ns3:principalAmount>
                <ns3:currency>{if ($ccap/ns2:CCAP_O_0003_0005) then fn:data($ccap/ns2:CCAP_O_0003_0006) else()}</ns3:currency>
                <ns3:amount>
{
                      let $num := fn:string(fn:data($ccap/ns2:CCAP_O_0003_0005))
                      let $len := string-length($num)
                      let $decimalString := concat(
                       xs:int( substring($num, 1, $len - 2)), '.', 
                        substring($num, $len - 1, 2)
                      )
                      return xs:decimal($decimalString)
                    }
</ns3:amount>
            </ns3:principalAmount> 
<ns3:maturityAmount>
  <ns3:currency>{fn:data($ccap/ns2:CCAP_O_0003_0006)}</ns3:currency>
  <ns3:amount>{
                      let $num := fn:string(fn:data($capd/*:CAPD_O_0013))
                      let $len := string-length($num)
                      let $decimalString := concat(
                        xs:int( substring($num, 1, $len - 2)), '.', 
                        substring($num, $len - 1, 2)
                      )
                      return xs:decimal($decimalString)
                    }</ns3:amount>
</ns3:maturityAmount>
            <ns3:holdAmount>   
                <ns3:currency>{fn:data($ccap/ns2:CCAP_O_0003_0006)}</ns3:currency>
                <ns3:amount>0.00</ns3:amount>
            </ns3:holdAmount>
            <ns3:rollOverAmount>
                <ns3:currency>{fn:data($ccap/ns2:CCAP_O_0003_0006)}</ns3:currency>
                <ns3:amount>0.00</ns3:amount>
            </ns3:rollOverAmount>
<ns3:maturityDate>
            {let $date := fn:data($ccap/ns2:CCAP_O_0003_0003) return 
            concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
            </ns3:maturityDate>
           
            <ns3:depositDate>
            {let $date := fn:data($capd/*:CAPD_O_0005) return 
            concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
            </ns3:depositDate>
             <ns3:currentPrincipalAmount>
                <ns3:currency>{fn:data($capd/*:CAPD_O_0009)}</ns3:currency>
                <ns3:amount>
{
                      let $num := fn:string(fn:data($capd/*:CAPD_O_0008))
                      let $len := string-length($num)
                      let $decimalString := concat(
                         xs:int(substring($num, 1, $len - 2)), '.', 
                        substring($num, $len - 1, 2)
                      )
                      return xs:decimal($decimalString)
                    }
</ns3:amount>
            </ns3:currentPrincipalAmount>
            <ns3:openingDate>
            {let $date := fn:data($capd/*:CAPD_O_0005) return 
            concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
            </ns3:openingDate>
            <ns3:valueDate>
            {let $date := fn:data($capd/*:CAPD_O_0005) return 
            concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
            </ns3:valueDate>
            <ns3:module>CON</ns3:module>
            <ns3:accountDisplayName>{fn:data($ccap/ns2:CCAP_O_0003_0002)}</ns3:accountDisplayName>
              <ns3:productId>{fn:data($TDProductDetails/ns4:Response[ns4:PRAZO_MAXIMO = $daysDuration][1]/ns4:ID)}</ns3:productId> 
     <ns3:rolloverType>
{
  let $val1 := fn:data($capd/*:CAPD_O_0012)
  let $val2 := fn:data($capd/*:CAPD_O_0011)
  return
    if ($val1 = 'S') then 'A'
    else if ($val1 = 'N' and $val2 = 'N') then 'P'
    else if ($val1 = 'N' and $val2 = 'S') then 'I'
    else ()
}
</ns3:rolloverType>
            <ns3:certificate>
                <!-- <ns3:dictionaryArray></ns3:dictionaryArray> -->
                <ns3:certificateNo></ns3:certificateNo>
            </ns3:certificate>
            <!-- redeemptionDetails to be added here -->
           <!-- <ns3:accrualDetails></ns3:accrualDetails> -->
            <ns3:holdingPattern>SINGLE</ns3:holdingPattern>
            <ns3:isNomineeRegistered>false</ns3:isNomineeRegistered>
            <ns3:sweepinProvider>false</ns3:sweepinProvider>
            <ns3:sortCode>{substring(xs:string(fn:data($capd/*:CAPD_O_0001)), 1, 3)} 
            </ns3:sortCode>
            <ns3:hostRelationshipCode></ns3:hostRelationshipCode>
          <!--  <ns3:balance>
                <ns3:currency>{fn:data($capd/*:CAPD_O_0009)}</ns3:currency>
                <ns3:amount>{fn-bea:format-number(fn:data($capd/*:CAPD_O_0008), '0.00')}</ns3:amount>
            </ns3:balance> -->
            
        </ns3:accounts>
	else()
        }
        </ns3:data>
    </ns3:TDBasicDetailsResponse>
};

local:func($CAPD_Response, $CCAP_Response,$userIdVar,$TDProductDetails)