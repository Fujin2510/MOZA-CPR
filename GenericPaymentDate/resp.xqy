xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/bankadate";
(:: import schema at "../BankDateService/Resources/BankaDate.xsd" ::)
declare namespace ns3="http://www.mozabank.org/genericPaymentDate";
(:: import schema at "GENERIC_PAYMENT_DATE.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ptfi";
(:: import schema at "PTFI.xsd" ::)

declare variable $Resp as element() (:: schema-element(ns1:Response) ::) external;
declare variable $ptfi as element() (:: schema-element(ns2:Response) ::) external;

declare function local:func($Resp as element() (:: schema-element(ns1:Response) ::), 
                            $ptfi as element() (:: schema-element(ns2:Response) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
    <ns3:Response>
       <ns2:data>
    <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns3:result>
            <ns3:externalReferenceId></ns3:externalReferenceId>
         
          <ns3:status>success</ns3:status>
            
<ns3:errorList>
<ns3:code></ns3:code>
<ns3:message></ns3:message>
</ns3:errorList>
            <ns3:warningList></ns3:warningList>
        </ns3:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        <ns3:dateDetails>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:networkDate>{
          let $date := fn:data($Resp/ns1:data/ns1:businessValueDate)
          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
        }</ns3:networkDate>
            <ns3:instructionDate>{
            let $date := fn:string(fn:current-date())
              return concat(fn:substring($date, 1, 10),'T00:00:00')}</ns3:instructionDate>
            <ns3:activationDate>{
          let $date := fn:data($Resp/ns1:data/ns1:businessValueDate)
          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
        }</ns3:activationDate>
        </ns3:dateDetails>
        </ns2:data>
    </ns3:Response>
};

local:func($Resp, $ptfi)