trigger OrderItemTrigger on OrderItem__c (after insert, after update, after delete, after undelete) {
    Set<Id> orderIds = new Set<Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (OrderItem__c oi : Trigger.new) {
            orderIds.add(oi.OrderId__c);
        }
    }
    if (Trigger.isDelete) {
        for (OrderItem__c oi : Trigger.old) {
            orderIds.add(oi.OrderId__c);
        }
    }
    
    Map<Id, List<OrderItem__c>> m = new Map<Id, List<OrderItem__c>>();
    for (OrderItem__c rec : [
        SELECT Id, OrderId__c, Price__c, Quantity__c
        FROM OrderItem__c
        WHERE OrderId__c IN :orderIds
    ]) {
        if (!m.containsKey(rec.OrderId__c)) {
            m.put(rec.OrderId__c, new List<OrderItem__c>());
        }
        m.get(rec.OrderId__c).add(rec);
    }
    
    List<Order__c> ordersToUpdate = new List<Order__c>();
    for (Id oId : m.keySet()) {
        Decimal totalPrice = 0;
        Decimal totalCount = 0;
        for (OrderItem__c itemRec : m.get(oId)) {
            totalPrice += (itemRec.Price__c * itemRec.Quantity__c);
            totalCount += itemRec.Quantity__c;
        }
        ordersToUpdate.add(new Order__c(
            Id = oId,
            TotalPrice__c = totalPrice,
            TotalProductCount__c = totalCount
        ));
    }
    
    if (!ordersToUpdate.isEmpty()) {
        update ordersToUpdate;
    }
}
