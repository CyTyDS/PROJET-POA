package telecom.v2.time;

import telecom.v2.connect.Call;

import java.util.HashMap;
import java.util.Map;

import telecom.v2.common.*;
import telecom.v2.connect.*;


public aspect TimeManagement {
	//On injecte une map qui associe un timer a un client ainsi que un accesseur et une méthode pour ajouter un couple client timer
    private Map<ICustomer, Timer> Call.timers = new HashMap<ICustomer, Timer>();
    
	public Timer Call.getTimer(ICustomer client) {
		return timers.get(client);
	}
	
	public void Call.addTimer(ICustomer client, Timer timer) {
		timers.put(client, timer);
	}
	
	//On initialise une nouvelle map de timers quand l'appel est initialisé
    after(Call cal) : Pointcuts.callInitialized() && this(cal) {
    	cal.timers = new HashMap<ICustomer, Timer>();
    }
	   
	    //Quand un nouveau client lance un appel on ajoute un timer et on le démarre.
	after(Call cal, ICustomer client) : Pointcuts.callCompleted() && this(cal) && args(client){
		cal.addTimer(client, new Timer());
		cal.getTimer(client).start();
	}
	
	after(Call cal, ICustomer client) : Pointcuts.callFinished() && this(cal) && args(client) {
		cal.getTimer(client).stop();
		// TODO ICI FAUDRA QU ON TRACE LE TEMPS DE CO.
	}
}
