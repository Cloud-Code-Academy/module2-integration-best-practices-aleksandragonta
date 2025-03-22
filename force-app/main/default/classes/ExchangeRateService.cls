/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public class ExchangeRateService {
    
    // The named credential to use for the callout
    private static final String NAMED_CREDENTIAL = 'ExchangeRate_API';
    
    // The base currency to use for exchange rates
    private static final String BASE_CURRENCY = 'USD';
    
    /**
     * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
     * @return ExchangeRateWrapper containing the response data
     */
    public static ExchangeRateWrapper getLatestRates() {
        String responseBody = '';
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ExchangeRate_API' + '/latest/'+ BASE_CURRENCY);
        request.setMethod('GET');

        try{
            HttpResponse response = http.send(request);
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                responseBody = response.getBody();
            }else{
                throw new ExchangeRateException(
                'Error: Received status code: ' + response.getStatusCode() + ' - ' + response.getBody()
            );
            }
        }catch(Exception e){
            throw new ExchangeRateException(
                'Error: ' + e.getMessage()
            );
        }
        
        return ExchangeRateWrapper.parse(responseBody);
    }
    
    /**
     * @description Processes the exchange rate data and creates or updates records
     * @param rateData The wrapper containing exchange rate data
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        List<Exchange_Rate__c> exchangeRates = rateData.toExchangeRates();
        upsert exchangeRates External_ID__c;
        
        return exchangeRates;
    }
    
    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> updateExchangeRates() {
        
        ExchangeRateWrapper exchangeRateToInsert = getLatestRates();
        List<Exchange_Rate__c> processedRates = processRates(exchangeRateToInsert);
        
        return processedRates;
    }


public class ExchangeRateException extends Exception{}

}