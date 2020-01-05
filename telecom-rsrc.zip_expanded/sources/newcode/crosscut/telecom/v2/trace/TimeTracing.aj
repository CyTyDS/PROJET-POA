package telecom.v2.trace;
import telecom.v2.connect.*;
import telecom.v2.common.Pointcuts;
import telecom.v2.trace.SimulationTracing;


public aspect TimeTracing {
	
	private static final String TEMPS_CO = "Temps de connexion : ";
	private static final String SEC = " s";
	
	after(Call cal, ICustomer client) : Pointcuts.callFinished() && this(cal) && args(client) {
		cal.getTimer(client).stop();
    	System.out.println(SimulationTracing.indenter.getIndent() + TEMPS_CO + cal.getTimer(client).getTime() + SEC);
	}
}
