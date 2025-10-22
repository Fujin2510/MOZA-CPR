xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/POP_OBDX";
(:: import schema at "../Schema/POP.xsd" ::)
declare namespace ns2="http://xmlns.oracle.com/oxp/service/v2";
(:: import schema at "../Schema/ReportService.wsdl" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func(
    $Request as element() (:: schema-element(ns1:Request) ::),
    $userIdVar as xs:string
) as element()? (:: schema-element(ns2:runReport) ::) {

    let $reportPath :=
        if ($Request/ns1:type = "PTFI") then
            "/~weblogic/MozaReports/ProofOfPaymentPTFIReport.xdo"
        else if ($Request/ns1:type = "PTFZ") then
            "/~weblogic/MozaReports/ProofOfPaymentPTFZReport.xdo"
        else if ($Request/ns1:type = "TFCM") then
            "/~weblogic/MozaReports/ProofOfPaymentTFCMReport.xdo"
        else if ($Request/ns1:type = "INSS") then
            "/~weblogic/MozaReports/ProofOfPaymentINSSReport.xdo"
        else if ($Request/ns1:type = "PAGS") then
            "/~weblogic/MozaReports/ProofOfPaymentPAGSReport.xdo"
        else if ($Request/ns1:type = "PASI") then
            "/~weblogic/MozaReports/ProofOfPaymentPASIReport.xdo"
        else if ($Request/ns1:type = "CORO") then
            "/~weblogic/MozaReports/ProofOfPaymentCOROReport.xdo"
        else
            ()

    return
        if ($reportPath) then
            <ns2:runReport xmlns:ns2="http://xmlns.oracle.com/oxp/service/v2">
                <ns2:reportRequest>
                    <ns2:reportAbsolutePath>{ $reportPath }</ns2:reportAbsolutePath>
                    <ns2:attributeTemplate>default</ns2:attributeTemplate>
                    <ns2:attributeFormat>pdf</ns2:attributeFormat>
                    <ns2:parameterNameValues>
                        <ns2:listOfParamNameValues>
                            <ns2:item>
<ns2:name>nrOperacao</ns2:name>
<ns2:values>
<ns2:item>{

      if ($Request/ns1:type = ("PTFI","PTFZ")) then

        if (contains(fn:data($Request/ns1:id), '#')) then

          substring-after(fn:data($Request/ns1:id), '#')

        else

          fn:data($Request/ns1:id)

      else

        fn:data($Request/ns1:id)

    }</ns2:item>
</ns2:values>
</ns2:item>
                            <ns2:item>
                                <ns2:name>user</ns2:name>
                                <ns2:values>
                                    <ns2:item>{ $userIdVar }</ns2:item>
                                </ns2:values>
                            </ns2:item>
                        </ns2:listOfParamNameValues>
                    </ns2:parameterNameValues>
                </ns2:reportRequest>
                <ns2:userID>weblogic</ns2:userID>
                <ns2:password>Moza7JiH4Dln</ns2:password>
            </ns2:runReport>
        else
        <error>{concat("InvalidType: Invalid report type: ", string($Request/ns1:type))}</error>
};

local:func($Request,$userIdVar)