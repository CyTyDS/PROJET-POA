package telecom.v2.unicity;

import java.util.HashSet;
import java.util.Set;
import telecom.v2.common.*;
import telecom.v2.util.NotUniqueException;

public aspect EnforceUnicity {
	private Set<String> names = new HashSet<String>();
	
	declare error : Pointcuts.checkUniqueIdIsOk() : "UniqueId doit etre utilisé sur un attribut constant et de type String";
	
	before(String x) : Pointcuts.checkUnicity() && args(x) {
		for (String name : names) {
			if (name.equals(x)) {
				throw new NotUniqueException("Unicité non respectée : " + x);
			}
		}
		names.add(x);
	}
}
