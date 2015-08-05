/**
 * Created by RasMisha on 08/05/2015
 */
 public with sharing class PaginatorFilterItem {

 	private String condition;
 	private Boolean active;

 	private PaginatorFilterItemListener listener;

	public PaginatorFilterItem(String newCondition, Boolean newActive) {
		condition = newCondition;
		active = newActive;
	}

	public override String toString() {
		return PaginatorUtils.LEFT_BRACKET + condition + PaginatorUtils.RIGHT_BRACKET;
	}

	public void switchOn() {
		Boolean oldValue = active;
		active = true;
		if (oldValue != active && listener !=null) {
			listener.filterActiveWasChanged();
		}
	}

	public void switchOff() {
		Boolean oldValue = active;
		active = false;
		if (oldValue != active && listener !=null) {
			listener.filterActiveWasChanged();
		}
	}

	public void setListener(PaginatorFilterItemListener newListener) {
		if (listener != null) {
			throw new PaginatorException();
		}

		listener = newListener;
	}

	public void removeListener() {
		listener = null;
	}

}