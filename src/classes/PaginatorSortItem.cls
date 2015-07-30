/**
 * Created by RasMisha on 07/30/2015
 */
public with sharing class PaginatorSortItem {

	private static String ILLEGAL_SORT_TYPE_MESSAGE = 'Sort Type must have one of two values: PaginatorSortItem.SORT_TYPE_ASC or PaginatorSortItem.SORT_TYPE_DESC';
	private static String SORT_ITEM_ALREADY_IN_USED = 'Sort item already in used.';

	public static Integer SORT_TYPE_ASC = 0;
	public static Integer SORT_TYPE_DESC = 1;

	public String field {get; private set;}
	public Integer sortType {get; private set;}

	private PaginatorSortItemListener listener = null;

	public PaginatorSortItem(String field) {
		this(field, SORT_TYPE_ASC);
	}

	public PaginatorSortItem(String field, Integer sortType) {
		this.field = field;
		this.sortType = sortType;

		if (sortType != SORT_TYPE_ASC && sortType != SORT_TYPE_DESC) {
			throw new PaginatorException(ILLEGAL_SORT_TYPE_MESSAGE);
		}
	}

	public override String toString() {
		return (' ' + field + (sortType == SORT_TYPE_ASC ? ' ASC ' : ' DESC '));
	}

	public void reverseSortType() {
		/*
		* I know about this solution: 
		* sortType = (sortType + 1) % 2
		* but please, understand
		*/
		if (sortType == SORT_TYPE_ASC) {
			sortType = SORT_TYPE_DESC;
		} else {
			sortType = SORT_TYPE_ASC;
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
