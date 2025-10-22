xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/TDMaturityAmountCalculation";
(:: import schema at "Schema/TD_MATURITY_AMOUNT_CALCULATION.xsd" ::)
declare namespace ns1="http://www.mozabank.org/getTDProductDetails";
(:: import schema at "Schema/GetTDProductDetails.xsd" ::)

declare variable $Response-getTDProductDetails as element() (:: schema-element(ns1:Response) ::) external;
declare variable $principleAmountVar as xs:string external;
declare variable $dateVar as xs:string external;
declare variable $maturityAmount as xs:string external;
declare function local:func($Response-getTDProductDetails as element() (:: schema-element(ns1:Response) ::),$principleAmountVar,$dateVar,$maturityAmount) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>SUCCESS</ns2:status> 
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:principalAmount>
                <ns2:currency>{fn:data($Response-getTDProductDetails/ns1:MOEDA)}</ns2:currency>
                <ns2:amount>{
                  fn-bea:format-number(
                    xs:decimal(fn:data($principleAmountVar)) div 100,
                    '0.00'
                  )
                }</ns2:amount>
            </ns2:principalAmount>
       <ns2:maturityDate>{ 
              let $substringDate := xs:date(concat(substring($dateVar, 1, 4), "-", substring($dateVar, 5, 2), "-", substring($dateVar, 7, 2)))
              let $daysToAdd := xs:integer(fn:data($Response-getTDProductDetails/ns1:PRAZO_MINIMO))
              let $finalDate := $substringDate + xs:dayTimeDuration(concat("P", $daysToAdd, "D"))
              return concat(string($finalDate), "T00:00:00")
            }</ns2:maturityDate>
             <ns2:maturityAmount>
                <ns2:currency>{fn:data($Response-getTDProductDetails/ns1:MOEDA)}</ns2:currency>
                <ns2:amount>{$maturityAmount}</ns2:amount>
            </ns2:maturityAmount>
            <ns2:tenure>
                <ns2:days>{fn:data($Response-getTDProductDetails/ns1:PRAZO_MINIMO)}</ns2:days>
                <ns2:months>0</ns2:months>
                <ns2:years>0</ns2:years>
            </ns2:tenure>
            <ns2:interestRate>{fn:data($Response-getTDProductDetails/ns1:TAXA_JURO)}</ns2:interestRate>
        </ns2:data>
    </ns2:Response>
};

local:func($Response-getTDProductDetails,$principleAmountVar,$dateVar,$maturityAmount)