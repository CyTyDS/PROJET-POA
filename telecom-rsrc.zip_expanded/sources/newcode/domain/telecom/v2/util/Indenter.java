package telecom.v2.util;

public class Indenter {
	    
	    private int level;
	    private String s;
	    
	    public Indenter(int level, String s) {
	        this.level = level;
	        this.s = s;
	    }
	    
	    public String getIndent() {
	        String str = "";
	        for (int i = 0 ; i < level ; ++i) {
	            str += s;
	        }
	        return str;
	    }
	    
	    public int getLevel() {
	        return level;
	    }
	    
	    public void setLevel(int level) {
	        this.level = level;
	    }
	    
	    public String getS() {
	        return s;
	    }
	    
	    public void setS(String s) {
	        this.s = s;
	    }
	}
