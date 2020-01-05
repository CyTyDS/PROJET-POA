package telecom.v2.trace;
import org.aspectj.lang.JoinPoint;

import telecom.v2.common.Pointcuts;
import telecom.v2.trace.SimulationMessages;

public privileged aspect SimulationTracing {
	
	private SimulationFormatter indenter = new SimulationFormatter(0,"|  ");
	
	//Factorisation de code
	private void addMessageBefore(JoinPoint jp, Object x) {
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(),methName);
		System.out.print(indenter.getIndent());
		System.out.println(sm.format(jp));
		indenter.addLevel();
	}
	
	//Factorisation de code
	private void addMessageAfter(JoinPoint jp , Object x) {
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		indenter.removeLevel();
		System.out.print(indenter.getIndent());
		System.out.println(sm.format(jp));
		if (indenter.getLevel() == 0) {
			System.out.println();
		}
	}
	

	//Avant tout les appel a des methode de customer ()
	before(Object x) : (Pointcuts.customerCall() || Pointcuts.customerHangUp() 
			|| Pointcuts.customerPickUp()) && target(x) {
		JoinPoint jp = thisJoinPoint;
		addMessageBefore(jp,x);
	}
		
	//Apres tout les appel a des methode de customer ()
	after(Object x) : ((Pointcuts.customerCall() || Pointcuts.customerHangUp() 
			|| Pointcuts.customerPickUp()) && target(x)) {
		JoinPoint jp = thisJoinPoint;
		addMessageAfter(jp,x);
	}
	
	//Avant tout les appel a des methode de call ()
	before(Object x) : (Pointcuts.callInvite() || Pointcuts.callHangUp() 
	|| Pointcuts.callPickUp()) && target(x) {
		JoinPoint jp = thisJoinPoint;
		addMessageBefore(jp,x);
	}
	
	//Apres tout les appel a des methode de call ()
	after(Object x) : ((Pointcuts.callInvite() || Pointcuts.callHangUp() 
			|| Pointcuts.callPickUp()) && target(x)) {
		JoinPoint jp = thisJoinPoint;
		addMessageAfter(jp,x);
	}
	
	after() : Pointcuts.testsCall() {
		System.out.println("----------------------------------------");
	}
	
//	after(telecom.v2.connect.Connection x) : Pointcuts.connectionPending() && this(x) {
//		System.out.println(indenter.getIndent() 
//				+ x.getClass().getSimpleName() + '@' + Integer.toHexString(x.hashCode()) 
//				+ "(null -> PENDING)");
//	}
//	
//	after(telecom.v2.connect.Connection x) : Pointcuts.connectionComplete() && this(x) {
//		System.out.println(indenter.getIndent() 
//				+ x.getClass().getSimpleName() + '@' + Integer.toHexString(x.hashCode()) 
//				+ "(PENDING -> COMPLETE)");
//	}
//	
//	after(telecom.v2.connect.Connection x) : Pointcuts.connectionDropped() && this(x) {
//		System.out.println(indenter.getIndent() 
//				+ x.getClass().getSimpleName() + '@' + Integer.toHexString(x.hashCode()) 
//				+ "(COMPLETE -> DROPPED)");
//	}
}
