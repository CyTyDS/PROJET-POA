package telecom.v2.common;

public aspect Pointcuts {
	
	//Detecte le début d'un appel
	public pointcut callInitialized() : initialization(telecom.v2.connect.Call.new(..));
	
	// Detecte le fait qu'un client décroche (passage de l'état de la connection en COMPLETED)
    public pointcut callCompleted() : withincode(* telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
    
	// Detecte la fin d'un appel (changement de l'état de la connection en DROPPED)
	public pointcut callFinished() : withincode(void telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..)));
	
}
