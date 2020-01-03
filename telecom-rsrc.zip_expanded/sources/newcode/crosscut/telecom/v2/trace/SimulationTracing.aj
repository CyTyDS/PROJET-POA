package telecom.v2.trace;
import org.aspectj.lang.JoinPoint;

import telecom.v2.common.Pointcuts;
import telecom.v2.trace.SimulationMessages;

public aspect SimulationTracing {
	
	private SimulationFormatter indenter = new SimulationFormatter(0,"| ");
	
	//Factorisation de code
	private void addMessageBefore(JoinPoint jp, Object x) {
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(),methName);
		System.out.print(indenter.getIndent());
		System.out.println(sm.format(jp));
		indenter.addLevel();
		//indenter ici ou dans l'advice
	}
	
	//Factorisation de code
	private void addMessageAfter(JoinPoint jp , Object x) {
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		System.out.print(indenter.getIndent());
		System.out.println(sm.format(jp));
		indenter.removeLevel();

	}
	
	//Avant tout les appel a des methode de customer (TODO)
	before(Object x) : (Pointcuts.customerCall() || Pointcuts.customerHangUp() 
			|| Pointcuts.customerPickUp()) && target(x) {
		JoinPoint jp = thisJoinPoint;
		addMessageBefore(jp,x);
	}
	//Apres tout les appel a des methode de customer (TODO)
	after(Object x) : ((Pointcuts.customerCall() || Pointcuts.customerHangUp() 
			|| Pointcuts.customerPickUp()) && target(x)) {
		JoinPoint jp = thisJoinPoint;
		addMessageAfter(jp,x);
	}
	
	//Avant tout les appel a des methode de call (TODO)
	before(Object x) : (Pointcuts.callInvite() || Pointcuts.callHangUp() 
	|| Pointcuts.callPickUp()) && target(x) {
		JoinPoint jp = thisJoinPoint;
		addMessageBefore(jp,x);
	}
	
	//Apres tout les appel a des methode de call (TODO)
	after(Object x) : ((Pointcuts.callInvite() || Pointcuts.callHangUp() 
			|| Pointcuts.callPickUp()) && target(x)) {
		JoinPoint jp = thisJoinPoint;
		addMessageAfter(jp,x);
	}
	
	

}
