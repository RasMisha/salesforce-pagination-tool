/**
 * Created by RasMisha on 07/30/2015
 */
public with sharing class PaginatorSortItem {

	private static String ILLEGAL_SORT_TYPE_MESSAGE = 'Sort type cannot be null.';
	private static String SORT_ITEM_ALREADY_IN_USED = 'Sort item already in used.';

	public String field {get; private set;}
	public PaginatorSortType sortType {get; private set;}

	private PaginatorSortItemListener listener = null;

	public PaginatorSortItem(String field) {
		this(field, PaginatorSortType.ASCENDING);
	}

	public PaginatorSortItem(String field, PaginatorSortType sortType) {
		if (sortType == null) {
			throw new PaginatorException(ILLEGAL_SORT_TYPE_MESSAGE);
		}

		this.field = field;
		this.sortType = sortType;
	}

	public override String toString() {
		return (' ' + field + (sortType == PaginatorSortType.ASCENDING ? ' ASC ' : ' DESC '));
	}

	public void reverseSortType() {
		if (sortType == PaginatorSortType.ASCENDING) {
			sortType = PaginatorSortType.DESCENDING;
		} else {
			sortType = PaginatorSortType.ASCENDING;
		}

		if (listener != null) {
			listener.sortDirectionWasChanged();
		}
	}

	public void setListener(PaginatorSortItemListener newListener) {
		if (listener == null) {
			listener = newListener;
		} else {
			throw new PaginatorException(SORT_ITEM_ALREADY_IN_USED);
		}
	}

	public void removeListener() {
		listener = null;
	}

}