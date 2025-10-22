xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org";
(:: import schema at "BranchDates.xsd" ::)
declare namespace ns1="http://www.mozabank.org/bankadate";
(:: import schema at "BankaDate.xsd" ::)

declare variable $branchIdVar as xs:string external;
declare variable $BankadatesResponse as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($BankadatesResponse as element() (:: schema-element(ns1:Response) ::),$branchIdVar as xs:string) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
    <ns2:data>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId> 
             <ns2:status>{if(fn:data($BankadatesResponse/ns1:status) != '') then fn:upper-case(fn:data($BankadatesResponse/ns1:status)) else 'FAILURE'}</ns2:status>
             {if(fn:data($BankadatesResponse/ns1:status) != '') then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>)  }
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:branchId>{$branchIdVar}</ns2:branchId>
        <ns2:currentDate>{let $date := fn:data($BankadatesResponse/ns1:data/ns1:businessValueDate) return 
concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}</ns2:currentDate>
        <ns2:previousWorkingDate>{let $date := fn:data($BankadatesResponse/ns1:data/ns1:businessValueDate) return  concat(xs:date(concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))) - xs:dayTimeDuration('P1D'),'T00:00:00')}</ns2:previousWorkingDate>
        <ns2:nextWorkingDate>{let $date := fn:data($BankadatesResponse/ns1:data/ns1:businessValueDate) return concat(xs:date(concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))) + xs:dayTimeDuration('P1D') ,'T00:00:00')}</ns2:nextWorkingDate>
    </ns2:data>
    </ns2:Response>
};
 
local:func($BankadatesResponse,$branchIdVar)