package telecom.v2.billing;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;
import telecom.v2.common.Pointcuts;

public privileged aspect BillManagement {
	// On injecte un prix a l'appel avec ses accesseurs.
	int Call.price;
	
	public int Call.getPrice() {
		return price;
	}
	public void Call.setPrice(int newPrice) {
		price = newPrice;
	}
	
	//on injecte une map statique qui associe pour un client un prix avec un getteur
	private Map<ICustomer, Integer> Call.prices = new HashMap<ICustomer, Integer>();
	public Map<ICustomer, Integer> Call.getPrices() {
		return prices;
	}
	
	//Après l'appel, on facture.
	after(Call cal, ICustomer client) : Pointcuts.callFinished()  && this(cal) && args(client) {
		try {
			//On vérifie la localisation pour savoir comment on facture.
			if (cal.getCaller().getAreaCode() == client.getAreaCode()) {
				int price = cal.getTimer(client).getTime() * Type.LOCAL.rate;
				cal.getPrices().put(client, price);
				cal.price += price;
			} else {
				int price = cal.getTimer(client).getTime() * Type.NATIONAL.rate;
				cal.getPrices().put(client, price);
				cal.price += price;	
			}
		} catch (IllegalArgumentException | SecurityException e) {
			e.printStackTrace();
		} 
	}

	//On reprend les outils de la V1    
    enum State { PENDING, COMPLETE, DROPPED }

    enum Type {
        LOCAL(3),
        NATIONAL(10);
        private int rate;
        Type(int r) {
            rate = r;
        }
        @Override
        public String toString() {
            return name().toLowerCase();
        }
    }
}
