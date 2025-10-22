xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns3="http://www.mozabank.org/TD_DETAILS";
(:: import schema at "../Schema/TD_DETAILS%201.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns4="http://www.mozabank.org/getTDProductDetails";
(:: import schema at "../../TermDeposit/Resources/Schema/GetTDProductDetails.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::) external;
declare variable $CCAPResponse as element() (:: schema-element(ns2:Response) ::) external;
declare variable $accountIdVar as xs:string external;
declare variable $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::) external;
 
declare function local:func($CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::), 
                            $CCAPResponse as element() (:: schema-element(ns2:Response) ::),$accountIdVar,
                             $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
  let $errCode := fn:data($CAPDResponse/ns1:errorCode)

  return
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns3:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($CCAPResponse/ns2:errorCode) = 'C') then 
                 (
                    <ns3:errorList>
                      <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CAPDResponse/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns3:code>
                      <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CAPDResponse/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN',substring-after(xs:string(fn:data($CAPDResponse/ns1:errorMessage/ns1:messages[1])),'-')) }</ns3:message>
                    </ns3:errorList>)
                 else if($errCode = 'A') then 
                 (
                    <ns3:errorList>
                      <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns3:code>
                      <ns3:message>{fn:data($CAPDResponse/ns1:errorMessage/ns1:messages[1])}</ns3:message>
                    </ns3:errorList>)
                 else (
                    <ns3:errorList>
                      <ns3:code>ERR001</ns3:code>
                      <ns3:message>Invalid backend response</ns3:message>
                    </ns3:errorList>)
                }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
			{
                         if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 
            let $ccap := $CCAPResponse/ns2:operationData/ns2:CCAP_O_0003[ns2:CCAP_O_0003_0001 = $accountIdVar]
            let $initialDate := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0005)
                      let $initDate := xs:date(concat(substring($initialDate,1,4),'-',substring($initialDate,5,2),'-',substring($initialDate,7,2)))
                      let $dueDate := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0006)
                      let $dDate :=  xs:date(concat(substring($dueDate,1,4),'-',substring($dueDate,5,2),'-',substring($dueDate,7,2)))
                      let $duration := $dDate - $initDate
                       let $daysDuration :=  days-from-duration($dDate - $initDate)
			return
            <ns3:account>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCAPResponse/ns2:user)}</ns3:partyId>
                <ns3:accountId>{fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0001)}</ns3:accountId>
                <ns3:branchId>{fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0003)}</ns3:branchId>
                <ns3:currency>{fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0009)}</ns3:currency>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:availableBalance>
                    <ns3:currency>{fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0009)}</ns3:currency>
                    <ns3:amount>
{
                let $raw := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0008)
                let $rawStr := string($raw)
                let $length := string-length($rawStr)
                return
                  if ($length gt 2) then
                    xs:decimal(concat(substring($rawStr, 1, $length - 2), '.', substring($rawStr, $length - 1)))
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
</ns3:interestRate>

                <ns3:principalAmount>
                    <ns3:currency>{fn:data($ccap/ns2:CCAP_O_0003_0006)}</ns3:currency>
                    <ns3:amount>
{
                let $raw := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0008)
                let $rawStr := string($raw)
                let $length := string-length($rawStr)
                return
                  if ($length gt 2) then
                    xs:decimal(concat(substring($rawStr, 1, $length - 2), '.', substring($rawStr, $length - 1)))
                  else ()
                  
              }
</ns3:amount>
                </ns3:principalAmount>
 
                <ns3:maturityAmount>
<ns3:currency>{fn:data($ccap/ns2:CCAP_O_0003_0006)}</ns3:currency>
<ns3:amount>
{
                let $raw := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0008)
                let $rawStr := string($raw)
                let $length := string-length($rawStr)
                return
                  if ($length gt 2) then
                    xs:decimal(concat(substring($rawStr, 1, $length - 2), '.', substring($rawStr, $length - 1)))
                  else ()
                  
              }
</ns3:amount>
</ns3:maturityAmount>
                <ns3:holdAmount>
                    <ns3:currency>MZN</ns3:currency>
                    <ns3:amount>0.00</ns3:amount>
                </ns3:holdAmount>
                <ns3:rollOverAmount>
                    <ns3:currency></ns3:currency>
                    <ns3:amount></ns3:amount>
                </ns3:rollOverAmount>
                <ns3:maturityDate>
                {let $date := fn:data($ccap/ns2:CCAP_O_0003_0003) return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:maturityDate>
                <ns3:depositDate>
                {let $date := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0005) return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:depositDate>
                <ns3:currentPrincipalAmount>
                    <ns3:currency>{fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0009)}</ns3:currency>
                    <ns3:amount>
{
                let $raw := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0008)
                let $rawStr := string($raw)
                let $length := string-length($rawStr)
                return
                  if ($length gt 2) then
                    xs:decimal(concat(substring($rawStr, 1, $length - 2), '.', substring($rawStr, $length - 1)))
                  else ()
                  
              }
</ns3:amount>
                </ns3:currentPrincipalAmount>
                <ns3:openingDate>
                {let $date := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0005) return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:openingDate>
                <ns3:valueDate>
                {let $date := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0005) return 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
                </ns3:valueDate>
                <ns3:module>CON</ns3:module>
                <ns3:accountDisplayName>{fn:data($ccap/ns2:CCAP_O_0003_0002)}</ns3:accountDisplayName>
                <ns3:productId>{fn:data($TDProductDetails/ns4:Response[ns4:PRAZO_MAXIMO = $daysDuration][1]/ns4:ID)}</ns3:productId> 
            <!--    <ns3:rolloverType>
                {
                  let $val := fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0012)
                  return
                    if ($val = 'S') then 'I'
                    else ()
                }
                </ns3:rolloverType> -->
<!-- Hard coded as Per Confirmation from Obdx/Bhadri on 14-06-->
   <ns3:rolloverType>I</ns3:rolloverType>
                <ns3:certificate>
                    <ns3:certificateNo></ns3:certificateNo>
                </ns3:certificate>
                <ns3:accrualDetails></ns3:accrualDetails>
                <ns3:holdingPattern>SINGLE</ns3:holdingPattern>
                <ns3:sweepinProvider>false</ns3:sweepinProvider>
                <ns3:sortCode>{substring(fn:data($CAPDResponse/ns1:operationData/ns1:CAPD_O_0001), 1, 3)}</ns3:sortCode>
                <ns3:hostRelationshipCode></ns3:hostRelationshipCode>
 
                <ns3:isNomineeRegistered></ns3:isNomineeRegistered>
            </ns3:account>
            else()
			}
        </ns3:data>
    </ns3:Response>
};

local:func($CAPDResponse, $CCAPResponse,$accountIdVar,$TDProductDetails)