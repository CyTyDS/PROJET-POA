package telecom.v2.trace;

import java.util.HashSet;
import java.util.Set;

import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;
import telecom.v2.common.Pointcuts;

public aspect TracingManagement {

	private final Set<ICustomer> Call.dropped = new HashSet<ICustomer>();
	private final Set<ICustomer> Call.ourPending = new HashSet<ICustomer>();
	
	public Set<ICustomer> Call.getDropped() {
		return dropped;
	}
	
	public Set<ICustomer> Call.getPending() {
		return ourPending;
	}

	/**
	 * Formate l'affichage d'un ensemble de ICustomer en chaîne de caractères.
	 */
	private String Call.setToString(Set<ICustomer> s) {
        String result = "|";
        boolean empty = true;
        for (ICustomer x : s) {
            if (empty) {
            	empty = false;
            } else {
                result += " ";
            }
            result += x.getName();
        }
        return result;
    }
	

	//TODO traitement de includes()
	
	/**
	 * Formate l'affichage de l'instance de Call en chaîne de caractères.
	 */
	public String Call.toString() {
		String result = "<" + getCaller().getName();
		result += setToString(getPending());
        result += setToString(getReceivers());
        result += setToString(getDropped());
        return result + ">";
	}
	
	after(Call ca, ICustomer cust) : Pointcuts.callHangUp() && this(ca) && args(cust) {
		ca.dropped.add(cust);
	}
	after(Call ca, ICustomer cust) : Pointcuts.callInvite() && this(ca) && args(cust) {
		ca.ourPending.add(cust);
	}
	after(Call ca, ICustomer cust) : Pointcuts.callPickUp() && this(ca) && args(cust) {
		ca.ourPending.remove(cust);
	}
	
}
