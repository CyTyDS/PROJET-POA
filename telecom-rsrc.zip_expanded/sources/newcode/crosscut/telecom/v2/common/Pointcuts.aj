package telecom.v2.common;

import telecom.v2.unicity.UniqueId;

public aspect Pointcuts {
	
	//Detecte le début d'un appel
	public pointcut callInitialized() : initialization(telecom.v2.connect.Call.new(..));
	
	// Detecte le fait qu'un client décroche (passage de l'état de la connection en COMPLETED)
    public pointcut callCompleted() : withincode(void telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
    
	// Detecte la fin d'un appel (changement de l'état de la connection en DROPPED)
	public pointcut callFinished() : withincode(void telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..)));
	
	// Detecte l'unicité d'un client
	// Si le nom d'un client n'est pas unique, une NotUniqueException est levée
	public pointcut checkUnicity() : set(@UniqueId final String telecom.v2.connect.*.*);
	
	// Detecte si l'utilisation de l'annotation UniqueId est correcte
	public pointcut checkUniqueIdIsOk() : set(@UniqueId !final !String telecom.v2.connect.*.*);
}
