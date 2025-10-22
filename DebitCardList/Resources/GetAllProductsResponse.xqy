xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/ccar/obdx";
(:: import schema at "../DEBIT_CARD_LIST.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/ccar";
(:: import schema at "../CCAR1.xsd" ::)
declare namespace dvm="http://www.oracle.com/osb/xpath-functions/dvm";
declare variable $Request as element() (:: schema-element(ns2:CCARResponse) ::) external;

declare function local:func($Request as element() (:: schema-element(ns2:CCARResponse) ::)) as element() (:: schema-element(ns1:DebitCardListResponse) ::) {
    let $errCode := fn:data($Request/ns2:errorCode)
    return
    <ns1:DebitCardListResponse>
    <ns1:data>
        <ns1:dictionaryArray></ns1:dictionaryArray>
        <ns1:referenceNo></ns1:referenceNo>
        <ns1:result> 
            <ns1:externalReferenceId></ns1:externalReferenceId>

                <ns1:status>{ if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }</ns1:status>
                {
                    if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
                    else if (fn:data($Request/ns2:errorCode) = 'C') then 
                    (
                        <ns1:errorList>
                            <ns1:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Request/ns2:errorMessage/ns2:messages[1])), '-'), 'ErrorCode', 'ERR001') }</ns1:code>
                            <ns1:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Request/ns2:errorMessage/ns2:messages[1])), '-'), 'ErrorMessageEN',  substring-after(xs:string(fn:data($Request/ns2:errorMessage/ns2:messages[1])), '-')) }</ns1:message>
                        </ns1:errorList>
                    )
                    else if ($errCode = '906' or $errCode = 'A') then 
                    (
                        <ns1:errorList>
                            <ns1:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', 'ERR001') }</ns1:code>
                            <ns1:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN',  substring-after(xs:string(fn:data($Request/ns2:errorMessage/ns2:messages[1])), '-')) }</ns1:message>
                        </ns1:errorList>
                    )
                    else
                    (
                        <ns1:errorList>
                            <ns1:code>ERR001</ns1:code>
                            <ns1:message>Invalid backend response</ns1:message>
                        </ns1:errorList>
                    )
                }
			
            <ns1:warningList></ns1:warningList>
        </ns1:result>
        <ns1:hasMore></ns1:hasMore>
        <ns1:totalRecords></ns1:totalRecords>
        <ns1:startSequence></ns1:startSequence>
        {
         if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then
       
       for $debitList in $Request/ns2:operationData/ns2:CCAR_O_0003[ns2:CCAR_O_0003_0013 = 'CARD' and (ns2:CCAR_O_0003_0011 = 'Normal' or ns2:CCAR_O_0003_0011 = 'Lista Negra' or ns2:CCAR_O_0003_0011 = 'Lista cinzenta' or ns2:CCAR_O_0003_0011 = 'Capturado a não devolver')] 
       return
        <ns1:debitCardList> 
                 
                <ns1:accountId>{fn:data($debitList/ns2:CCAR_O_0003_0006)}</ns1:accountId>
                <ns1:branchId>{substring(xs:string(fn:data($debitList/ns2:CCAR_O_0003_0006)),1,3)}</ns1:branchId>
                <ns1:partyId>{fn:data($Request/ns2:user)}</ns1:partyId>
                
             <!-- CDOD CALL Response
             <ns1:branchName>{fn:data($debitList/ns2:CCAR_O_0003_0004)}</ns1:branchName> -->
             
                <ns1:id>{fn:data($debitList/ns2:CCAR_O_0003_0001)}</ns1:id>
                <ns1:displayValue>{fn:data($debitList/ns2:CCAR_O_0003_0004)}</ns1:displayValue>
                <ns1:currencyCode>{fn:data($debitList/ns2:CCAR_O_0003_0002)}</ns1:currencyCode>
				
				  <ns1:status>{let $value1:= fn:data($debitList/ns2:CCAR_O_0003_0011) 
				return 
				if ($value1 = 'Normal') then 'ACTIVE' 
				else if ($value1 = 'Lista Negra') then 'HOTLISTED'
				else if ($value1 = 'Lista cinzenta') then 'HOTLISTED'
				else if ($value1 = 'Capturado a não devolver') then 'HOTLISTED'
				else 'INACTIVE' }</ns1:status>
                <ns1:issueDate>{let $isDate := xs:string(fn:data($debitList/ns2:CCAR_O_0003_0007)) return concat(substring($isDate, 1, 4), '-', substring($isDate, 5, 2), '-', substring($isDate, 7, 2),'T00:00:00') }</ns1:issueDate>
                <ns1:expiryDate>{let $isDate := xs:string(fn:data($debitList/ns2:CCAR_O_0003_0008))return concat(substring($isDate, 1, 4), '-', substring($isDate, 5, 2), '-', substring($isDate, 7, 2),'01T00:00:00') }</ns1:expiryDate>
                <ns1:applicationDate>{let $isDate := xs:string(fn:data($debitList/ns2:CCAR_O_0003_0007))return concat(substring($isDate, 1, 4), '-', substring($isDate, 5, 2), '-', substring($isDate, 7, 2),'T00:00:00') }</ns1:applicationDate>
                <ns1:cardRenewalDate>{let $isDate := xs:string(fn:data($debitList/ns2:CCAR_O_0003_0008))return concat(substring($isDate, 1, 4), '-', substring($isDate, 5, 2), '-', substring($isDate, 7, 2),'01T00:00:00') }</ns1:cardRenewalDate>
                <ns1:cardActivationDate>
                    
{
                  if (fn:data($debitList/ns2:CCAR_O_0003_0011) = 'Normal') then
                    let $date := xs:string(fn:data($debitList/ns2:CCAR_O_0003_0012))
                    return 
                      if (normalize-space($date) != '') then
                        concat(
                          substring($date, 1, 4), '-', 
                          substring($date, 5, 2), '-', 
                          substring($date, 7, 2), 
                          'T00:00:00'
                        )
                      else ()
                  else ()
                }    

 </ns1:cardActivationDate>
                 { if(fn:data($debitList/ns2:CCAR_O_0003_0011) = 'Normal') then 
                 <ns1:dispatchStatus>D</ns1:dispatchStatus>
                else()}
                 { if(fn:data($debitList/ns2:CCAR_O_0003_0011) = 'Normal') then 
                 <ns1:pinMailStatus>D</ns1:pinMailStatus>
                    else()}
                
               <ns1:cardHolderName>{fn:data($debitList/ns2:CCAR_O_0003_0004)}</ns1:cardHolderName>
<ns1:cardType>{
  let $val := fn:lower-case(fn:normalize-space(fn:data($debitList/ns2:CCAR_O_0003_0018)))
  return
    if (contains($val, "gold")) then "Cartao Moza Gold"
    else if (contains($val, "classic")) then "Cartao Moza Classic"
    else if (contains($val, "particular")) then "Cartao Txapo Txapo"
    else ""
}</ns1:cardType>
                <ns1:isPrimary>true</ns1:isPrimary>
                <ns1:internationalUsage>true</ns1:internationalUsage>
                <ns2:debitCardLimitDetails> 
                        <ns2:dictionaryArray></ns2:dictionaryArray>
                        <ns2:unit></ns2:unit>
                        <ns2:amount> 
                            <ns2:currency>MZN</ns2:currency>
                            <ns2:amount>0</ns2:amount>
                        </ns2:amount>
                        <ns2:count>0</ns2:count>
                        <ns2:limitType>ATM</ns2:limitType>  
                        <ns2:maxLimitAmount>
                            <ns2:currency>MZN</ns2:currency> 
                            <ns2:amount></ns2:amount>
                        </ns2:maxLimitAmount> 
                </ns2:debitCardLimitDetails> 
                <ns2:debitCardInternationalLimitDetails> 
                        <ns2:dictionaryArray></ns2:dictionaryArray>
                        <ns2:unit></ns2:unit>
                        <ns2:amount> 
                            <ns2:currency>MZN</ns2:currency>
                            <ns2:amount></ns2:amount>
                        </ns2:amount>
                        <ns2:count>0</ns2:count>
                        <ns2:limitType>ATM</ns2:limitType> 
                        <ns2:maxLimitAmount>
                            <ns2:currency>MZN</ns2:currency> 
                            <ns2:amount>0</ns2:amount>
                        </ns2:maxLimitAmount> 
                </ns2:debitCardInternationalLimitDetails>
                <ns2:totalAmountLimit> 
                    <ns2:currency>MZN</ns2:currency>
                    <ns2:amount>0</ns2:amount>
                </ns2:totalAmountLimit>
                <ns2:totalAmountMaxLimit> 
                    <ns2:currency>MZN</ns2:currency>
                    <ns2:amount>0</ns2:amount>
                </ns2:totalAmountMaxLimit>     
        </ns1:debitCardList> else()
        }
        </ns1:data>
    </ns1:DebitCardListResponse>
};

local:func($Request)