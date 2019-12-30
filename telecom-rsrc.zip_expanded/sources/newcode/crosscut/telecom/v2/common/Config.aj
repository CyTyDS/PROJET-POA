package telecom.v2.common;
import telecom.v2.time.*;
import telecom.v2.billing.*;

public aspect Config {
	declare precedence : Pointcuts, BillManagement, TimeManagement;
}
