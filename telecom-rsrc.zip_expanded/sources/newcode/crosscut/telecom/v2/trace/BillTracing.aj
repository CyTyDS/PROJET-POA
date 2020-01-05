package telecom.v2.trace;

import telecom.v2.common.Pointcuts;
import telecom.v2.connect.*;

public privileged aspect BillTracing {
	private Call testCallRef;
		
	private static final String CARRIAGE_RETURN = "\n";
	private static final String CO_COST_CONST = "montant de la connexion ";
	private static final String CO_COSTTIME_CONST = " s pour un montant de ";
	private static final String LOCAL_CONST = "locale ";
	private static final String NATIONAL_CONST = "longue distance ";
	private static final String HASBEENCO_CONST = "a été connecté ";
	private static final String NULLCOST_CUST_CONST = " s pour un montant de 0";
	private static final String AWAITOF_CONST = "est en attente de ";
	private static final String COST_SUP_TO_CONST = "et son montant sera supérieur à ";
	
	
	after(ICustomer client, Call cal): Pointcuts.globalHangUp() && args(client) && target(cal)  {
		String msg = SimulationTracing.indenter.getIndent();
		if (!(cal.getCaller() == client)) {
			msg += CO_COST_CONST;
			if (cal.getCaller().getAreaCode() == client.getAreaCode()) {
				msg += LOCAL_CONST;
			} else {
				msg += NATIONAL_CONST;
			}
			System.out.println(msg + ": " + cal.getPrices().get(client));
		}
	}

	after() returning(ICall cal): Pointcuts.getCallCalled() && Pointcuts.withinTest() {
		testCallRef = (Call) cal;
	}

	after() : Pointcuts.testsCall() {
		String msg = "";
		int callerTime = 0;
		for (ICustomer cus : testCallRef.getDropped()) {
			msg += cus.getName() + "[" + cus.getAreaCode() + "] " + HASBEENCO_CONST + testCallRef.getTimer(cus).getTime() + NULLCOST_CUST_CONST + CARRIAGE_RETURN;
			callerTime += testCallRef.getTimer(cus).getTime();
		}
		msg += testCallRef.getCaller().getName() + "[" + testCallRef.getCaller().getAreaCode() + "] ";
		
		if (testCallRef.noCalleePending()) {
			msg += HASBEENCO_CONST + callerTime + CO_COSTTIME_CONST + testCallRef.getPrice() + CARRIAGE_RETURN;
		} else {
			msg += AWAITOF_CONST;
			for (ICustomer c : testCallRef.pending.keySet()) {
				msg += c.getName() + " ";
			}
			msg += COST_SUP_TO_CONST + testCallRef.getPrice() + CARRIAGE_RETURN;
		}
		msg = msg + CARRIAGE_RETURN;
		System.out.println(msg);
	}
}
