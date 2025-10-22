xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org";
(:: import schema at "../Schema/BRANCH_DATE.xsd" ::)
declare namespace ns1="http://www.mozabank.org/bankadate";
(:: import schema at "../Schema/BANKADATE.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $branchIdVar as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$branchIdVar as xs:string) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
           <ns2:status>{if(fn:data($Response/ns1:status) != '') then fn:upper-case(fn:data($Response/ns1:status)) else 'FAILURE'}</ns2:status>
             {if(fn:data($Response/ns1:status) != '') then () else(
            <ns2:errorList>
                <ns2:code></ns2:code>
                <ns2:message></ns2:message>
            </ns2:errorList>)  }
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:branchCode>{$branchIdVar}</ns2:branchCode>
          <ns2:currentDate>{let $date := fn:data($Response/ns1:data/ns1:businessValueDate) return 
concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}</ns2:currentDate>
        <ns2:previousDate>{let $date := fn:data($Response/ns1:data/ns1:businessValueDate) return  concat(xs:date(concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))) - xs:dayTimeDuration('P1D'),'T00:00:00')}</ns2:previousDate>
        <ns2:nextDate>{let $date := fn:data($Response/ns1:data/ns1:businessValueDate) return concat(xs:date(concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))) + xs:dayTimeDuration('P1D') ,'T00:00:00')}</ns2:nextDate>
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$branchIdVar)