public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static List<Product__c> getProducts(String searchKey, String typeFilter, String familyFilter) {
        String c = '%' + searchKey + '%';
        String q = 'SELECT Id, Name, Description__c, Type__c, Family__c, Price__c, Image__c ' +
                   'FROM Product__c ' +
                   'WHERE (Name LIKE :c OR Description__c LIKE :c)';
        if (!String.isBlank(typeFilter)) {
            q += ' AND Type__c = :typeFilter';
        }
        if (!String.isBlank(familyFilter)) {
            q += ' AND Family__c = :familyFilter';
        }
        return Database.query(q);
    }
    
    @AuraEnabled
    public static Id createOrderAndOrderItems(Id accountId, List<OrderItemWrapper> items) {
        Order__c o = new Order__c(Name='Auto ' + DateTime.now(), AccountId__c=accountId);
        insert o;
        List<OrderItem__c> lst = new List<OrderItem__c>();
        for (OrderItemWrapper w : items) {
            lst.add(new OrderItem__c(
                OrderId__c=o.Id,
                ProductId__c=w.productId,
                Quantity__c=w.quantity,
                Price__c=w.price
            ));
        }
        insert lst;
        return o.Id;
    }
    
    public class OrderItemWrapper {
        @AuraEnabled public Id productId;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal price;
    }
}
