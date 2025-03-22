/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {
    public String base_code;
    public String time_last_update_unix;
    public Map<String,Decimal> conversion_rates;
    public String externalId;
    /**
     * @description Converts the wrapper data to a list of Exchange_Rate__c records
     * @return List<Exchange_Rate__c> The list of exchange rate records
     */
    public List<Exchange_Rate__c> toExchangeRates() {
        List<Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();

        for (String currencyCode : conversion_rates.keySet()) {
            Exchange_Rate__c exRateRecord = new Exchange_Rate__c();
            exRateRecord.Base_Currency__c = base_code; 
            exRateRecord.Target_Currency__c = currencyCode;
            exRateRecord.Rate__c = conversion_rates.get(currencyCode);
            exRateRecord.Last_Updated__c = Datetime.valueOf(time_last_update_unix.indexOf(',') + 2);
            exRateRecord.External_ID__c = base_code + '_' + currencyCode; 
            exchangeRates.add(exRateRecord);
        }
        
        return exchangeRates; 
    }
    
    /**
     * @description Static method to parse the JSON response into the wrapper class
     * @param jsonResponse The JSON response from the API
     * @return ExchangeRateWrapper The parsed wrapper instance
     */
    public static ExchangeRateWrapper parse(String jsonResponse) {
        
    return (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);
    }
}