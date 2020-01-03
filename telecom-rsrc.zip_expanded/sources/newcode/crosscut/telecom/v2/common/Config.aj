package telecom.v2.common;
import telecom.v2.time.*;
import telecom.v2.billing.*;
import telecom.v2.trace.*;

public aspect Config {
	declare precedence : Pointcuts, SimulationTracing, BillManagement, TimeManagement, TracingManagement;
}
