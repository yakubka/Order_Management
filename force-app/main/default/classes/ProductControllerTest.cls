@isTest
private class ProductControllerTest {
    @isTest static void testGetProducts() {
        Product__c p = new Product__c(Name='LaptopTest', Description__c='Desc', Type__c='Type 1', Family__c='Family 1', Price__c=1000);
        insert p;
        Test.startTest();
        List<Product__c> res = ProductController.getProducts('LaptopTest','Type 1','Family 1');
        Test.stopTest();
        System.assertEquals(1, res.size());
        System.assertEquals('LaptopTest', res[0].Name);
    }
    
    @isTest static void testCreateOrderAndTrigger() {
        Account a = new Account(Name='Test');
        insert a;
        Product__c p = new Product__c(Name='PhoneX', Price__c=500);
        insert p;
        ProductController.OrderItemWrapper w = new ProductController.OrderItemWrapper();
        w.productId = p.Id;
        w.quantity = 2;
        w.price = 500;
        Test.startTest();
        Id oId = ProductController.createOrderAndOrderItems(a.Id, new List<ProductController.OrderItemWrapper>{ w });
        Test.stopTest();
        Order__c o = [SELECT Id, TotalPrice__c, TotalProductCount__c FROM Order__c WHERE Id=:oId];
        System.assertEquals(1000, o.TotalPrice__c);
        System.assertEquals(2, o.TotalProductCount__c);
    }
}
