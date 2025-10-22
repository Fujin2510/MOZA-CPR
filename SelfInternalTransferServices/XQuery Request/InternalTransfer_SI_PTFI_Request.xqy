xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/INTERNAL_TRANSFER_SI";
(:: import schema at "../Schema/OBDXSchema/INTERNAL_TRANSFER_SI.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ptfi";
(:: import schema at "../Schema/MSBSchema/PTFI.xsd" ::) 
declare variable $input as element() external;

declare variable $Internal_Transfer as element() (:: schema-element(ns1:Request) ::) external; 

declare function local:func($Internal_Transfer as element() (:: schema-element(ns1:Request) ::)) 
                            as element() (:: schema-element(ns3:Request) ::) {
                            
    <ns3:Request>
        <ns3:user>{fn:data($Internal_Transfer/ns1:partyId)}</ns3:user>
        <ns3:password></ns3:password>
        <ns3:origin>P</ns3:origin>
        <ns3:channelCode>INT</ns3:channelCode>
        <ns3:version>R30</ns3:version>
        <ns3:licenceKey>licenseKey</ns3:licenceKey>
        <ns3:sessionId>00000000</ns3:sessionId>
        <ns3:transactionCode>PTFI</ns3:transactionCode>
        <ns3:operationData>
            <ns3:PTFI_I_0001>{substring-after(fn:data($Internal_Transfer/ns1:debitAccountId),'~')}</ns3:PTFI_I_0001>
            <ns3:PTFI_I_0002>{fn:data($Internal_Transfer/ns1:beneficiary/ns1:accountId)}</ns3:PTFI_I_0002>
<ns3:PTFI_I_0003>
  { xs:decimal(fn:data($Internal_Transfer/ns1:amount/ns1:amount)) * 100 }
</ns3:PTFI_I_0003>
            <ns3:PTFI_I_0004>{fn:data($Internal_Transfer/ns1:amount/ns1:currency)}</ns3:PTFI_I_0004>
            <ns3:PTFI_I_0005>  { 
               concat("TRF-", fn:data($Internal_Transfer/ns1:remarks)) 
               }</ns3:PTFI_I_0005>
            <ns3:PTFI_I_0006>  
               { 
               concat("TRF-", fn:data($Internal_Transfer/ns1:remarks)) 
               }
            </ns3:PTFI_I_0006>
            <ns3:PTFI_I_0007>P</ns3:PTFI_I_0007>
            <ns3:PTFI_I_0008>{substring(fn:data($Internal_Transfer/ns1:instructionDetails/ns1:startDate/ns1:dateString),1,8)}</ns3:PTFI_I_0008>
            <ns3:PTFI_I_0009>{substring(fn:data($Internal_Transfer/ns1:instructionDetails/ns1:endDate/ns1:dateString),1,8)}</ns3:PTFI_I_0009>
            <ns3:PTFI_I_0010>{
                let $freqCo := fn:data($Internal_Transfer/ns1:instructionDetails/ns1:frequencyCode) 
                let $freqNo := fn:data($Internal_Transfer/ns1:instructionDetails/ns1:frequencyNo)
                return
                if($freqCo= 'D' and $freqNo = '1') then 'D'
                else  if($freqCo= 'W' and $freqNo = '1') then 'W'
                else  if($freqCo= 'W' and $freqNo = '2') then 'Q'
                else  if($freqCo= 'M' and $freqNo = '2') then 'I' 
                else  if($freqCo= 'M' and $freqNo = '3') then 'T' 
                else  if($freqCo= 'M' and $freqNo = '6') then 'S' 
                else  if($freqCo= 'M' and $freqNo = '1') then 'M' 
                  else  if($freqCo= 'M' and $freqNo = '12') then 'Y' 
                else()
                }</ns3:PTFI_I_0010>
            <ns3:PTFI_I_0011>{fn:data($Internal_Transfer/ns1:dictionaryArray/ns1:nameValuePairArray[ns1:genericName = 'com.finonyx.digx.cz.domain.payment.entity.network.CZNetworkPayment.PayeeEmailId']/ns1:value)}</ns3:PTFI_I_0011>
            <ns3:PTFO_I_00132>PTFI</ns3:PTFO_I_00132>
        </ns3:operationData> 
    </ns3:Request>
};

local:func($Internal_Transfer)