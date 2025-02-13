trigger OrderItemTrigger on OrderItem__c (after insert, after update, after delete, after undelete) {
    Set<Id> oIds = new Set<Id>();
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (OrderItem__c n : Trigger.new) {
            oIds.add(n.OrderId__c);
        }
    }
    if (Trigger.isDelete) {
        for (OrderItem__c o : Trigger.old) {
            oIds.add(o.OrderId__c);
        }
    }
    Map<Id, List<OrderItem__c>> m = new Map<Id, List<OrderItem__c>>();
    for (OrderItem__c r : [SELECT Id, OrderId__c, Price__c, Quantity__c FROM OrderItem__c WHERE OrderId__c IN :oIds]) {
        if (!m.containsKey(r.OrderId__c)) {
            m.put(r.OrderId__c, new List<OrderItem__c>());
        }
        m.get(r.OrderId__c).add(r);
    }
    List<Order__c> upd = new List<Order__c>();
    for (Id i : m.keySet()) {
        Decimal tp = 0, tc = 0;
        for (OrderItem__c rec : m.get(i)) {
            tp += rec.Price__c * rec.Quantity__c;
            tc += rec.Quantity__c;
        }
        upd.add(new Order__c(Id=i, TotalPrice__c=tp, TotalProductCount__c=tc));
    }
    if (!upd.isEmpty()) {
        update upd;
    }
}
