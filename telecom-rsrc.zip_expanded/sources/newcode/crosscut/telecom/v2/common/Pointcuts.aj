package telecom.v2.common;

public aspect Pointcuts {
	
	//Detecte le début d'un appel
	public pointcut callInitialized() : initialization(telecom.v2.connect.Call.new(..));
	
	// Detecte le fait qu'un client décroche (passage de l'état de la connection en COMPLETED)
    public pointcut callCompleted() : withincode(void telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
    
	// Detecte la fin d'un appel (changement de l'état de la connection en DROPPED)
	public pointcut callFinished() : withincode(void telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..)));
	
	// Detect l'appel a call() d'un ICustomer
	public pointcut customerCall() : call(* telecom.v2.connect.ICustomer.call(..));
	
	// Detect l'appel a hangUp() d'un ICustomer
	public pointcut customerHangUp() : call(* telecom.v2.connect.ICustomer.hangUp(..));

	// Detect l'appel a pickUp() d'un ICustomer
	public pointcut customerPickUp() : call(* telecom.v2.connect.ICustomer.pickUp(..));

	// Detect l'appel a invite() d'un ICall
	public pointcut callInvite() : call(* telecom.v2.connect.ICall.invite(..));

	// Detect l'appel a hangUp() d'un ICall
	public pointcut callHangUp() : call(* telecom.v2.connect.ICall.hangUp(..));

	// Detect l'appel a pickUp() D'un ICall
	public pointcut callPickUp() : call(* telecom.v2.connect.ICall.pickUp(..));

}
