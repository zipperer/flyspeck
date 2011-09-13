package edu.pitt.math.jhol.ssreflect.parser.tree;

/**
 * move: x
 */
public class IntroNode extends TacticNode {
	// The object which is introduced
	private final ObjectNode obj;
	
	/**
	 * Default constructor
	 */
	public IntroNode(ObjectNode obj) {
		assert(obj != null);
		this.obj = obj;
	}

	@Override
	protected String getString() {
		return "intro " + obj;
	}

	@Override
	protected void beginTranslation(StringBuffer buffer, GoalContext context) {
		obj.beginTranslation(buffer, context);
	}

	@Override
	protected void endTranslation(StringBuffer buffer) {
		obj.endTranslation(buffer);
	}

	@Override
	protected void translate(StringBuffer buffer) {
		buffer.append('(');
		
		int type = obj.getType();
		if (type == ObjectNode.TERM) {
			// SPEC_TAC
			StringBuffer varBuffer = new StringBuffer();
			obj.translate(varBuffer);
			buffer.append("SPEC_TAC (");
			buffer.append(varBuffer);
			buffer.append(',');
			buffer.append(varBuffer);
			buffer.append(')');
		}
		else {
			// MP_TAC
			buffer.append("MP_TAC ");
			obj.translate(buffer);
		
			// Remove assumptions
			if (obj instanceof IdNode) {
				IdNode idObj = (IdNode) obj;
				if (idObj.isAssumption())
					buffer.append(" THEN REMOVE_THEN \"" + idObj.getId() + "\" (fun th -> ALL_TAC)"); 
			}
		}
		
		buffer.append(')');
	}
}