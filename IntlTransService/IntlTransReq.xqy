xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/internalTransfer";
(:: import schema at "INTERNAL_TRANSFER.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ptfi";
(:: import schema at "SelfTransferService/PTFI.xsd" ::)

declare variable $IntlTrans as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func(
    $IntlTrans as element() (:: schema-element(ns1:Request) ::),
    $UserIdVar as xs:string
) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{$UserIdVar}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>ac7e4cdb</ns2:sessionId>
        <ns2:transactionCode>PTFI</ns2:transactionCode>
        <ns2:operationData>
            <ns2:PTFI_I_0001>{
                let $acct := fn:data($IntlTrans/ns1:debitAccountId)
                return
                    if (contains($acct, "@~")) then
                        substring-after($acct, "@~")
                    else
                        $acct
            }</ns2:PTFI_I_0001>

            <ns2:PTFI_I_0002>{fn:data($IntlTrans/ns1:beneficiary/ns1:accountId)}</ns2:PTFI_I_0002>

<ns2:PTFI_I_0003>
  { xs:decimal(fn:data($IntlTrans/ns1:amount/ns1:amount)) * 100 }
</ns2:PTFI_I_0003>

            <ns2:PTFI_I_0004>{fn:data($IntlTrans/ns1:amount/ns1:currency)}</ns2:PTFI_I_0004>
            <ns2:PTFI_I_0005>TRF-tt</ns2:PTFI_I_0005>

            <ns2:PTFI_I_0006>{concat("TRF-", fn:data($IntlTrans/ns1:remarks))}</ns2:PTFI_I_0006>
            <ns2:PTFI_I_0007>E</ns2:PTFI_I_0007>

            <ns2:PTFI_I_0008>{
                let $dateString := fn:data($IntlTrans/ns1:paymentDate/ns1:dateString)
                return
                    if ($dateString != '' and exists($dateString)) then
                        substring($dateString, 1, 8)
                    else
                        let $currentDate := fn:current-date()
                        return concat(
                            substring(string($currentDate), 1, 4),
                            substring(string($currentDate), 6, 2),
                            substring(string($currentDate), 9, 2)
                        )
            }</ns2:PTFI_I_0008>

            <ns2:PTFI_I_0009>{' '}</ns2:PTFI_I_0009>

            {
                if (fn:data($IntlTrans/ns1:dictionaryArray/ns1:nameValuePairArray
                                [ns1:genericName = 'com.finonyx.digx.cz.domain.payment.entity.network.CZNetworkPayment.PayeeEmailId']
                                /ns1:value) != '')
                then
                    <ns2:PTFI_I_0011>{
                        fn:data($IntlTrans/ns1:dictionaryArray/ns1:nameValuePairArray
                                [ns1:genericName = 'com.finonyx.digx.cz.domain.payment.entity.network.CZNetworkPayment.PayeeEmailId']
                                /ns1:value)
                    }</ns2:PTFI_I_0011>
                else ()
            }

            <ns2:PTFO_I_00132>PTFI</ns2:PTFO_I_00132>
        </ns2:operationData>

        <ns2:validation>
            <ns2:confirmationKey>
                <ns2:digitValues>X</ns2:digitValues>
                <ns2:digitPositions>X</ns2:digitPositions>
            </ns2:confirmationKey>
        </ns2:validation>
    </ns2:Request>
};

local:func($IntlTrans,$userIdVar)