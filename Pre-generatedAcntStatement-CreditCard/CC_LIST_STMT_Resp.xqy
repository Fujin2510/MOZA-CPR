xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3 = "http://msb.mozabanco.co.mz";
(:: import schema at "ExtractosWs.wsdl" ::)
declare namespace ns2 = "http://www.mozabanca.org/obdx/CC_LIST_STMT";
(:: import schema at "CC_LIST_STMT_OBDX.xsd" ::)

declare variable $ACCID as xs:string external;
declare variable $CC_LIST_STMT_RESP as element() (:: schema-element(ns3:ConsultarExtractosResponse) ::) external;

declare function local:func(
    $ACCID as xs:string,
    $CC_LIST_STMT_RESP as element() (:: schema-element(ns3:ConsultarExtractosResponse) ::)
) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray/>
            <ns2:referenceNo/>
            <ns2:result>
                <ns2:dictionaryArray/>
                <ns2:externalReferenceId/>
                <ns2:status>{
        if (fn:data($CC_LIST_STMT_RESP/ns3:output/status/codigo) = 0) 
        then 'SUCCESS' 
        else 'FAILURE'
      }</ns2:status>
                <!--<ns2:errorList/>-->
                <ns2:warningList/>
            </ns2:result>
            <ns2:hasMore/>
            <ns2:totalRecords/>
            <ns2:startSequence/>
           {
    for $CCSTMT in $CC_LIST_STMT_RESP/ns3:output/extractos/extracto
    return
        <ns2:creditCardStatements>
            <ns2:dictionaryArray/>
            <ns2:openingBalance/>
            <ns2:earnedPoints/>
            <ns2:redeemedPoints/>
            <ns2:closingBalance/>
            <ns2:id>{fn:data($ACCID)}</ns2:id>
            <ns2:statementDate>{
          let $date := fn:data($CCSTMT/dataExtracto)
          return concat($date,'T00:00:00')
        }</ns2:statementDate>
            <ns2:statmentItems/>
            
            
   {
  let $dataExtracto := fn:data($CCSTMT/dataExtracto)
  let $month := substring($dataExtracto, 6, 2)
  let $year := xs:integer(substring($dataExtracto, 1, 4))

  let $thirtydaybefore :=
    if ($month = '03') then
      if (($year mod 4 = 0 and $year mod 100 != 0) or ($year mod 400 = 0)) then
        xs:date($dataExtracto) - xs:dayTimeDuration("P29D")
      else
        xs:date($dataExtracto) - xs:dayTimeDuration("P28D")
    else
      ()  (: Empty if not March :)

  return
    if (exists($thirtydaybefore)) then
      let $formatted := concat(string($thirtydaybefore), "T00:00:00")
      return <ns2:fromDate>{$formatted}</ns2:fromDate>
    else
      ()
}
{
  let $dataExtracto := fn:data($CCSTMT/dataExtracto)
  let $month := substring($dataExtracto, 6, 2)

  let $thirtydaybefore :=
    if ($month != '03') then
      xs:date($dataExtracto) - xs:dayTimeDuration("P30D")
    else
      ()

  return
    if (exists($thirtydaybefore)) then
      let $formatted := concat(string($thirtydaybefore), "T00:00:00")
      return <ns2:fromDate>{$formatted}</ns2:fromDate>
    else
      ()
}

            <ns2:toDate>{
          let $date := fn:data($CCSTMT/dataExtracto)
          return concat($date,'T00:00:00')
        }</ns2:toDate>
        
        </ns2:creditCardStatements>
}

          <!--  <ns2:messages>
                <ns2:keyId/>
                <ns2:status>{
        if (fn:data($CC_LIST_STMT_RESP/ns3:output/status/codigo) = 0) 
        then 'SUCCESS' 
        else 'FAILURE'
      }</ns2:status>
                <ns2:codes/>
                <ns2:requestId/>
                <ns2:httpStatusCode/>
                <ns2:overrideAuthLevelsReqd/>
            </ns2:messages>-->
        </ns2:data>
    </ns2:Response>
};

local:func($ACCID, $CC_LIST_STMT_RESP)