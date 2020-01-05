package telecom.v2.common;

import telecom.v2.unicity.UniqueId;

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
	
	public pointcut globalHangUp() : call(* telecom.v2.connect.IC*.hangUp(..));
	public pointcut globalPickUp() : call(* telecom.v2.connect.IC*.pickUp(..));
	public pointcut globalInvite() : call(* telecom.v2.connect.IC*.invite(..));
	
	public pointcut callDropped() : withincode(* telecom.v2.connect.Call.hangUp(..)); 
	
	// Detecte les appels a getcall
	public pointcut getCallCalled() :call(* *.getCall(..));
	
	// Detecte les changements d'états des connections
	public pointcut connectionPending() : execution(telecom.v2.connect.Connection.new(..));
	public pointcut connectionComplete() : execution(* telecom.v2.connect.Connection.complete(..));
	public pointcut connectionDropped() : execution(* telecom.v2.connect.Connection.drop(..));
    
	//Detect l'appel aux differentes simumlation
	public pointcut testsCall() : call(void telecom.v2.simulate.Simulation.runTest*(..));
    public pointcut withinTest() : withincode(void telecom.v2.simulate.Simulation.runTest*(..));

	// Detecte l'unicité d'un client
	// Si le nom d'un client n'est pas unique, une NotUniqueException est levée
	public pointcut checkUnicity() : set(@UniqueId final String telecom.v2.connect.*.*);
	
	// Detecte si l'utilisation de l'annotation UniqueId est correcte
	public pointcut checkUniqueIdIsOk() : set(@UniqueId !final !String telecom.v2.connect.*.*);
}
