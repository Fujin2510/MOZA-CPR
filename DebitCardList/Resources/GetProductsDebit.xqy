xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/ccar";
(:: import schema at "../CCAR1.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/ccar/obdx";
(:: import schema at "../DEBIT_CARD_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:CCARResponse) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:CCARResponse) ::)) as element() (:: schema-element(ns2:DebitCardListResponse) ::) {
        <ns2:DebitCardListResponse>
     <ns2:data>
        <ns2:dictionaryArray>{fn:data($Request/*:coreLogKey)}</ns2:dictionaryArray>
         <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray>{fn:data($Request/*:transactionCode)}</ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId> 
         <ns2:status>{if(fn:data($Request/ns1:errorCode) = 0) then 'SUCCESS' else 'FAILURE'}
          </ns2:status>
          {if(fn:data($Request/ns1:errorCode) != 0) then 
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>
            else()
            } 
            <ns2:warningList></ns2:warningList>
        </ns2:result>
         <ns2:hasMore>{fn:data($Request/ns1:coreCancelationCode)}</ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
     {   for $req in  $Request/ns1:operationData/ns1:CCAR_O_0003[ns1:CCAR_O_0003_0013 = 'CARD'] return
        <ns2:debitCardList> 
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:accountId>{fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0006)}</ns2:accountId>
                <ns2:branchId>{fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0006)}</ns2:branchId>
                <ns2:partyId></ns2:partyId>
                
             <!-- CDOD CALL Response
             <ns2:branchName>{fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0004)}</ns2:branchName> -->
             
                <ns2:id></ns2:id>
                <ns2:displayValue>{concat(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0004),' ',fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0005))}</ns2:displayValue>
                <ns2:currencyCode>{fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0002)}</ns2:currencyCode>
                <ns2:status>{fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_00101)}</ns2:status>
               <ns2:issueDate>{if(xs:int(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0007)) = 0) then '' else concat(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0007),'T00:00:00')} </ns2:issueDate>
                 <ns2:expiryDate>{if(xs:int(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0008)) = 0) then '' else concat(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0008),'T00:00:00')}
                </ns2:expiryDate>
                <ns2:applicationDate>{if(xs:int(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0007)) = 0) then '' else concat(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0007),'T00:00:00')} </ns2:applicationDate>
                 <ns2:cardRenewalDate>{if(xs:int(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0008)) = 0) then '' else concat(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0008),'T00:00:00')}</ns2:cardRenewalDate>  
                 <ns2:cardActivationDate>{  let $cadDate := fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0011) return
					if($cadDate = 'Normal' and xs:int($cadDate) != 0) then  
					(<ns2:dateString>{concat($cadDate,'T00:00:00')}</ns2:dateString>)
                    else() } </ns2:cardActivationDate> 
                 { if(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0011) = 'Normal') then 
                 <ns2:dispatchStatus>D</ns2:dispatchStatus>
                else(<ns2:dispatchStatus>I</ns2:dispatchStatus>)}
                 { if(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0011) = 'Normal') then 
                 <ns2:pinMailStatus>D</ns2:pinMailStatus>
                    else()}
                
                <ns2:cardHolderName>{concat(fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0004),' ',fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0005))}</ns2:cardHolderName>
                <ns2:cardType>{fn:data($Request/*:operationData/*:CCAR_O_0003/*:CCAR_O_0003_0013)}</ns2:cardType>
                <ns2:isPrimary>true</ns2:isPrimary>
                <ns2:internationalUsage>true</ns2:internationalUsage>
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
        </ns2:debitCardList>
        }
        </ns2:data>
    </ns2:DebitCardListResponse>
};

local:func($Request)